# iOS AltStore Sideload Guide (Daily You)

## Prerequisites

- macOS machine with AltServer installed
- iPhone with AltStore installed
- Same Wi-Fi network for refresh

## Build Unsigned IPA

```bash
flutter pub get
flutter build ipa --release --no-codesign
```

IPA output is generated under:

- `build/ios/ipa/`

## Install via AltStore

1. Open AltStore on iPhone
2. Use `My Apps` -> `+`
3. Select Daily You IPA from Files
4. Confirm install completes and app launches

## Validation Checklist

- [ ] App launches on device
- [ ] Entry create/edit works
- [ ] Mixed media (photo/video) picker works
- [ ] Calendar/gallery/detail render without crash
- [ ] 7-day certificate refresh works with AltServer running

## Notes

- This flow targets personal sideloading only (no App Store distribution).
- If signing expires, reconnect to AltServer and refresh from AltStore.
