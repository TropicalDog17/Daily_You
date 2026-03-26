# Task Completion Checklist
When finishing changes in this repo:
1. Format changed Dart files: `dart format .` (or targeted paths).
2. Run lint/analyzer checks: `flutter analyze`.
3. Run relevant tests: `flutter test` plus any impacted integration tests.
4. Verify app startup or targeted flow with `flutter run` when behavior changed.
5. If release-related files were changed, validate version/changelog consistency (`pubspec.yaml`, `fastlane` changelogs, release scripts).