import Flutter
import Photos
import PhotosUI
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    let pluginRegistry = engineBridge.pluginRegistry
    GeneratedPluginRegistrant.register(with: pluginRegistry)

    guard let registrar = pluginRegistry.registrar(forPlugin: "LivePhotoImportPlugin") else {
      return
    }

    if #available(iOS 14.0, *) {
      LivePhotoImportPlugin.register(
        with: registrar
      )
    } else {
      LivePhotoImportUnavailablePlugin.register(
        with: registrar
      )
    }
  }
}

final class LivePhotoImportUnavailablePlugin: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "daily_you/media_import",
      binaryMessenger: registrar.messenger()
    )
    let instance = LivePhotoImportUnavailablePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "pickImagesWithMetadata" else {
      result(FlutterMethodNotImplemented)
      return
    }

    result(
      FlutterError(
        code: "unavailable",
        message: "Live Photo metadata import requires iOS 14 or newer.",
        details: nil
      )
    )
  }
}

@available(iOS 14.0, *)
final class LivePhotoImportPlugin: NSObject, FlutterPlugin, PHPickerViewControllerDelegate {
  private var pendingResult: FlutterResult?

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "daily_you/media_import",
      binaryMessenger: registrar.messenger()
    )
    let instance = LivePhotoImportPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "pickImagesWithMetadata" else {
      result(FlutterMethodNotImplemented)
      return
    }

    guard pendingResult == nil else {
      result(
        FlutterError(
          code: "busy",
          message: "A media picker request is already in progress.",
          details: nil
        )
      )
      return
    }

    let args = call.arguments as? [String: Any]
    let selectionLimit = (args?["selectionLimit"] as? Int) ?? 0

    var configuration = PHPickerConfiguration(photoLibrary: .shared())
    configuration.selectionLimit = selectionLimit
    configuration.filter = .images
    configuration.preferredAssetRepresentationMode = .current

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self

    pendingResult = result

    DispatchQueue.main.async {
      guard let presenter = self.topViewController(from: self.activeRootViewController()) else {
        let callback = self.pendingResult
        self.pendingResult = nil
        callback?(
          FlutterError(
            code: "no_presenter",
            message: "Unable to find a view controller to present the picker.",
            details: nil
          )
        )
        return
      }
      presenter.present(picker, animated: true)
    }
  }

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)

    guard let callback = pendingResult else {
      return
    }
    pendingResult = nil

    if results.isEmpty {
      callback([])
      return
    }

    let group = DispatchGroup()
    let lock = NSLock()
    var payloads: [[String: Any]] = []

    for pickerResult in results {
      group.enter()
      processPickerResult(pickerResult) { payload in
        if let payload {
          lock.lock()
          payloads.append(payload)
          lock.unlock()
        }
        group.leave()
      }
    }

    group.notify(queue: .main) {
      callback(payloads)
    }
  }

  private func processPickerResult(
    _ pickerResult: PHPickerResult,
    completion: @escaping ([String: Any]?) -> Void
  ) {
    let provider = pickerResult.itemProvider
    let typeIdentifier = UTType.image.identifier

    guard provider.hasItemConformingToTypeIdentifier(typeIdentifier) else {
      completion(nil)
      return
    }

    provider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { fileURL, _ in
      guard let fileURL else {
        completion(nil)
        return
      }

      let ext = fileURL.pathExtension.isEmpty ? "jpg" : fileURL.pathExtension
      let imageDestination = FileManager.default.temporaryDirectory.appendingPathComponent(
        "dy_pick_\(UUID().uuidString).\(ext)"
      )

      do {
        if FileManager.default.fileExists(atPath: imageDestination.path) {
          try FileManager.default.removeItem(at: imageDestination)
        }
        try FileManager.default.copyItem(at: fileURL, to: imageDestination)
      } catch {
        completion(nil)
        return
      }

      var payload: [String: Any] = [
        "imagePath": imageDestination.path,
        "isLivePhoto": false,
      ]

      guard let assetIdentifier = pickerResult.assetIdentifier else {
        completion(payload)
        return
      }

      let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
      guard let asset = fetchResult.firstObject else {
        completion(payload)
        return
      }

      let isLivePhoto = asset.mediaSubtypes.contains(.photoLive)
      payload["isLivePhoto"] = isLivePhoto

      guard isLivePhoto else {
        completion(payload)
        return
      }

      let resources = PHAssetResource.assetResources(for: asset)
      guard let pairedVideoResource = resources.first(where: { $0.type == .pairedVideo }) else {
        completion(payload)
        return
      }

      let videoDestination = FileManager.default.temporaryDirectory.appendingPathComponent(
        "dy_live_\(UUID().uuidString).mov"
      )

      let options = PHAssetResourceRequestOptions()
      options.isNetworkAccessAllowed = true

      PHAssetResourceManager.default().writeData(
        for: pairedVideoResource,
        toFile: videoDestination,
        options: options
      ) { error in
        if error == nil {
          payload["pairedVideoPath"] = videoDestination.path
        }
        completion(payload)
      }
    }
  }

  private func activeRootViewController() -> UIViewController? {
    if let activeScene = UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .first(where: { $0.activationState == .foregroundActive }),
      let root = activeScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
    {
      return root
    }

    return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
  }

  private func topViewController(from controller: UIViewController?) -> UIViewController? {
    guard let controller else {
      return nil
    }

    if let presented = controller.presentedViewController {
      return topViewController(from: presented)
    }

    if let navigation = controller as? UINavigationController {
      return topViewController(from: navigation.visibleViewController)
    }

    if let tab = controller as? UITabBarController,
      let selected = tab.selectedViewController
    {
      return topViewController(from: selected)
    }

    return controller
  }
}
