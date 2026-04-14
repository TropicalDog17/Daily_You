# Task completion checklist
- Format changed Dart files with `dart format`.
- Run targeted analysis with `flutter analyze <paths>`.
- Run relevant tests when practical (`flutter test` or a narrower target).
- If the change affects device-specific UI behavior, verify on the intended platform when feasible (for this project, iPhone runs use `flutter run -d 00008120-00080C362162601E`).
- Check `git diff` before finishing to ensure only intended edits were made.
