# Daily You project overview
- Purpose: Flutter diary and moment-tracking app for logging journal entries, moods, photos, and memories offline-first.
- Tech stack: Flutter/Dart app using Provider for state management, sqflite/storage-related packages for local persistence, and platform folders for Android/iOS/macOS/Linux/Windows.
- Structure: `lib/` contains app code (pages, widgets, providers, utilities), `assets/` contains icons/images, `integration_test/` holds integration tests, and platform folders (`android/`, `ios/`, etc.) contain native wrappers.
- Key UI areas include calendar widgets in `lib/widgets/`, including Material-style `entry_calendar.dart` and iOS-specific `ios_calendar_grid.dart`.
- Repo includes Nix development support via `flake.nix`/`flake.lock` and release helpers like `build_release.sh` and `prepare_release.sh`.
- Project-specific guidance is documented in `AGENTS.md` plus `agent_docs/flutter_rules.md` and `agent_docs/github.md`.
