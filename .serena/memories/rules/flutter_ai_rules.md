# Flutter AI Rules (Fetched and Remembered)
- Source URL: https://raw.githubusercontent.com/flutter/flutter/refs/heads/main/docs/rules/rules.md
- Fetched on: 2026-03-26
- Verified SHA-256: `756cecba8d066fe9888cc4451b8a60dc02203f89cf2ab7a88b44c7ffa7ec4bf2`
- Local snapshot: `.serena/flutter_ai_rules_source.md`

## Core directives to follow
- Write modern, maintainable Flutter/Dart code; prefer concise declarative style.
- Keep Flutter UI composition-first, immutable where possible, and break large build methods into smaller private widgets.
- Separate concerns with clear architecture layers (presentation/domain/data/core).
- Prefer built-in state management first; third-party state packages only when explicitly requested.
- Prefer `go_router` for app routing/deep links; use `Navigator` for short-lived local flows.
- Keep code quality high: clear naming, short focused functions, robust error handling, avoid silent failures.
- Follow Dart best practices: null safety, proper async/await, exhaustive switches, docs for public APIs.
- Use structured logging instead of `print`.
- Use `json_serializable` + `json_annotation` for JSON modeling where needed.
- Maintain test discipline across unit/widget/integration tests.
- Apply accessibility requirements (contrast, dynamic text scale, semantics, screen-reader checks).
- Keep theming centralized with `ThemeData`; support light/dark and consistent component theming.

## Working preference in this repo
- User preference: use Serena MCP tools whenever possible.