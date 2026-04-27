import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:daily_you/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  static final NotificationManager instance = NotificationManager._init();

  static FlutterLocalNotificationsPlugin? _notifications;

  bool justLaunched = true;

  bool get isInitialized => _notifications != null;

  FlutterLocalNotificationsPlugin get notifications {
    return _notifications!;
  }

  NotificationManager._init();

  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager() {
    return _instance;
  }

  NotificationManager._internal();

  Future<void> init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    _notifications = flutterLocalNotificationsPlugin;

    await _notifications!.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_notification'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        linux: LinuxInitializationSettings(defaultActionName: 'Log Today'),
      ),
    );
  }

  Future<bool> hasNotificationPermission() async {
    if (!isInitialized) {
      await init();
    }

    if (Platform.isAndroid) {
      var hasPermissions = await _notifications!
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();

      if (hasPermissions != null && hasPermissions) {
        return await requestAlarmPermission();
      }
    } else if (Platform.isIOS) {
      return await _notifications!
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return false;
  }

  Future<bool> requestAlarmPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

    if (androidInfo.version.sdkInt > 30) {
      //Request alarm permission
      var status = await Permission.scheduleExactAlarm.status;
      if (!status.isGranted) {
        status = await Permission.scheduleExactAlarm.request();
      }
      if (status.isGranted) {
        return true;
      }
      return false;
    }

    return true;
  }

  Future<void> dismissReminderNotification() async {
    if (!isInitialized) {
      return;
    }

    var activeNotifications = await NotificationManager.instance.notifications
        .getActiveNotifications();
    for (var notif in activeNotifications) {
      if (notif.id == 0) {
        await NotificationManager.instance.notifications.cancel(0);
      }
    }
  }

  Future<void> stopDailyReminders() async {
    if (!isInitialized) {
      return;
    }

    if (Platform.isAndroid) {
      await AndroidAlarmManager.cancel(0);
    } else if (Platform.isIOS) {
      await _notifications!.cancel(0);
    }
    await dismissReminderNotification();
  }

  Future<void> startScheduledDailyReminders() async {
    if (!isInitialized) {
      return;
    }

    if (Platform.isAndroid) {
      setAlarm(firstSet: true);
    } else if (Platform.isIOS) {
      final scheduledTime = calculateReminderDateTime(firstSet: true);
      await _scheduleIOSNotification(scheduledTime);
    }
  }

  Future<void> scheduleIOSNotification(DateTime scheduledTime) async {
    if (!Platform.isIOS || !isInitialized) {
      return;
    }
    await _scheduleIOSNotification(scheduledTime);
  }

  Future<void> _scheduleIOSNotification(DateTime scheduledTime) async {
    final notificationTitle = 'Log Today!';
    const notificationDescription = 'Your daily reminder is ready.';

    await _notifications!.zonedSchedule(
      0,
      notificationTitle,
      notificationDescription,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(iOS: DarwinNotificationDetails()),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: scheduledTime.toIso8601String(),
    );
  }
}
