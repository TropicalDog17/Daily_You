# Epic #15 Progress Tracker

Last updated: 2026-03-27
Epic: https://github.com/TropicalDog17/Daily_You/issues/15

## Delivery Scope (This Wave)

- In scope: #3, #6, #7, #8, #9, #10, #12, #4, and media-selection subset of #5
- Out of scope: #14 for this wave
- Epic closure decision: deferred final checkpoint (as requested)

## Definition of Done Mapping

- [x] Onboarding helps first-time users start an entry
- [x] User can select image/video media from library
- [x] User can browse mixed media on calendar/gallery/detail views
- [x] User can generate week/month/year compilation video
- [x] User can share generated compilation
- [x] User sees streak surface and risk reminder behavior
- [x] Offline-first and on-device storage preserved

## Milestone Status

- [x] Milestone 0: Tracking + baseline
- [x] Milestone 1: Media foundation (database + picker + playback + mixed-media rendering)
- [x] Milestone 2: Compilation + sharing
- [x] Milestone 3: Retention + onboarding (streak/risk reminder done; onboarding baseline done)
- [ ] Milestone 4: AltStore validation + closure review (build readiness validated, device sideload pending)

## Iteration Log

### 2026-03-26 — Iteration 1

- Added schema v4 for `entry_images` with `media_type` and `video_path`.
- Added mixed-media picker pipeline (image/video/live-pair detection heuristic on iOS).
- Added video thumbnail generation and persisted motion metadata.
- Added unified media preview badges for gallery/cards/calendar/detail/edit list.
- Added inline video playback for detail/fullscreen views.
- Added motion-aware share/download behavior.
- Added streak summary cards on Home and streak-risk reminder copy.
- Added first-run onboarding prompt on Home.
- Added markdown progress tracker and issue-tracking workflow.
- Added FFmpeg-backed compilation service and in-app compilation page with share/save actions.
- Built unsigned iOS archive successfully via `flutter build ipa --release --no-codesign` (archive generated, final sideload validation still pending).

### 2026-03-27 — Iteration 2

- Replaced the single-step home onboarding popup with a guided multi-step first-run flow.
- Added one-tap reminder quick setup during onboarding (notification permission + reminder enablement).
- Added explicit first-entry checklist card on Home when no entries exist.
- Added onboarding-discoverability tooltips to Home camera/create FAB actions.

## Risks / Open Work

- Integration test suite currently unstable in this environment and needs dedicated stabilization pass.
- `ffmpeg_kit_flutter_new` does not support Apple Silicon arm64 simulators, so compilation E2E tests must be validated on physical iOS hardware.
- Full Live Photo pairing depends on picker-delivered still/video pairs from iOS media APIs.
- iOS bundle identifier is still default (`com.example.responseTest`) and should be updated before long-term sideload usage.
- Optional "import from other apps" during onboarding (Issue #12 stretch requirement) is not integrated into the first-run flow yet.
