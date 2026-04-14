# Style and conventions
- Follow Flutter/Dart conventions from `agent_docs/flutter_rules.md`.
- Prefer concise, declarative Dart and composition over inheritance.
- Use `PascalCase` for classes, `camelCase` for members/functions, and `snake_case` for files.
- Keep functions focused and readable; avoid clever code.
- Use sound null safety and avoid unnecessary `!`.
- Keep widgets immutable where possible and prefer small reusable widgets.
- Lint baseline comes from `package:flutter_lints/flutter.yaml` via `analysis_options.yaml`.
- For this repo, preserve existing visual/style patterns unless a task explicitly requests broader UI changes.
