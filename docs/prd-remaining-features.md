# PRD: Daily You — Remaining Features to 1SE Parity

**Last updated:** 2026-04-09
**Epic:** TropicalDog17/Daily_You#15
**Target:** Personal-use iOS sideload via AltStore

---

## Current Architecture Snapshot

| Layer | State |
|-------|-------|
| DB | SQLite v3 — `entries` (id, text, mood, timeCreate, timeModified) + `entry_images` (id, entryId, imgPath, imgRank, timeCreate) |
| Media | `image_picker` for photos, `flutter_image_compress` for compression, `extended_image` for display |
| State | Provider-based (`EntriesProvider`, `EntryImagesProvider`, `ConfigProvider`) |
| Video | **Nothing** — no video_player, no ffmpeg, no media_type field |
| Platform | iOS Cupertino styling in place (tab bar, FABs, calendar grid) |

---

## Work Stream A: Video Foundation (Phase 1)

> **Goal:** A user can attach a video clip to a diary entry, play it back, and see it in the calendar.

### A1. DB Migration v3 -> v4 — Add media_type to entry_images

**Files:** `lib/models/image.dart`, `lib/database/app_database.dart`

- Add `media_type` TEXT column to `entry_images` (values: `image`, `video`, `live_photo`)
- Add `video_path` TEXT column (nullable) — for Live Photos, stores the paired MOV; for videos, stores the video file path (imgPath stores thumbnail)
- Migration: `ALTER TABLE entry_images ADD COLUMN media_type TEXT NOT NULL DEFAULT 'image'`
- Migration: `ALTER TABLE entry_images ADD COLUMN video_path TEXT`
- Bump DB version to 4
- Update `EntryImage` model, `fromJson`, `toJson`, `copy`, `EntryImageFields`

**Backward compat:** All existing rows default to `media_type = 'image'`, no data loss.

### A2. Video Picker — Extend media selection to videos

**Files:** `lib/widgets/entry_image_picker.dart`, `pubspec.yaml`

**New dependencies:**
```yaml
video_player: ^2.9.1        # playback
video_thumbnail: ^0.5.3     # generate poster frame
```

**Changes:**
- Add "Pick Video" option alongside existing camera/gallery buttons
- Use `image_picker.pickVideo()` (already supports video, just not wired up)
- On video selection:
  1. Generate thumbnail via `video_thumbnail` -> store as imgPath
  2. Copy video file to app storage -> store as video_path
  3. Set `media_type = 'video'`
- Enforce max duration (configurable, default 3s for 1SE feel) — trim UI optional, can just take first N seconds
- Skip `flutter_image_compress` for video thumbnails (they're already small)

### A3. Video Playback in Entry Detail

**Files:** `lib/pages/entry_detail_page.dart`, new `lib/widgets/video_player_widget.dart`

- When rendering an `EntryImage` with `media_type == 'video'`:
  - Show thumbnail with play button overlay
  - Tap -> inline `VideoPlayer` with controls (play/pause, scrubber)
  - Auto-pause when scrolled off screen
- In image carousel/gallery, video items show a play icon badge
- Reuse `video_player` package (lightweight, no native bridge issues on iOS)

### A4. Video Indicators in Calendar + Gallery

**Files:** `lib/widgets/ios_day_cell.dart`, `lib/widgets/entry_calendar.dart`, `lib/pages/gallery_page.dart`

- Calendar day cells: small video icon overlay on thumbnail when entry has video
- Gallery grid: video duration badge on video thumbnails (bottom-right)
- No structural changes needed — just conditional UI based on `media_type`

---

## Work Stream B: Live Photo Support (#3)

> **Goal:** When a user picks a Live Photo from iOS gallery, preserve both the still and motion components.

**Depends on:** A1 (media_type field), A3 (video playback)

### B1. Live Photo Detection + Import

**Files:** `lib/widgets/entry_image_picker.dart`

**Approach — PHPicker metadata (iOS only):**
- Use `image_picker` which returns the still image
- Use platform channel or `photo_manager` package to detect Live Photo pairs
- If Live Photo detected:
  - Store still as `imgPath`
  - Extract and store MOV component as `video_path`
  - Set `media_type = 'live_photo'`

**Fallback (simpler v1):**
- Treat Live Photos as static images (current behavior, just explicit)
- Add a config toggle: "Import Live Photos as video" — when enabled, extract the MOV and store as video
- This avoids the complexity of PHPicker metadata on first pass

### B2. Live Photo Playback

**Files:** `lib/widgets/video_player_widget.dart`, `lib/pages/entry_detail_page.dart`

- `live_photo` entries: show still image by default
- Long-press or force-touch -> play the MOV component (mimics iOS Photos behavior)
- Short tap -> full-screen image view (existing behavior)

---

## Work Stream C: Video Compilation (#6, #9)

> **Goal:** Generate an MP4 montage from selected entries and share it.

**Depends on:** A1-A3 (video foundation must exist first)

### C1. FFmpeg Integration

**New dependency:**
```yaml
ffmpeg_kit_flutter_min: ^6.0.3   # minimal build, smaller binary
```

> **Note:** `ffmpeg_kit_flutter_min` is the minimal variant — includes codecs for mp4/h264/aac only, ~15MB smaller than full. Sufficient for compilation.

> **iOS simulator caveat:** FFmpeg Kit does not support arm64 simulators. All compilation testing requires a physical device. Unit tests should mock the FFmpeg interface.

**New files:**
- `lib/services/compilation_service.dart` — wraps FFmpeg commands

**Compilation pipeline:**
1. Query entries in date range that have media (image or video)
2. For each entry:
   - If video: extract first N seconds (configurable, default 1s)
   - If image: create N-second still video (Ken Burns pan/zoom optional, static first)
3. Concatenate segments with crossfade transitions (0.3s)
4. Output MP4 (H.264, AAC silent or with optional music track)
5. Return file path for preview/share

**FFmpeg command pattern:**
```
# Image to video segment
-loop 1 -i image.jpg -t 1 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p segment_N.mp4

# Concat segments
-f concat -safe 0 -i list.txt -c copy output.mp4
```

### C2. Compilation UI Page

**New file:** `lib/pages/compilation_page.dart`

**UX flow:**
1. Entry point: FAB menu or app bar action on home/calendar page
2. Range selector: Week / Month / Year / Custom date range
3. Preview: scrollable list of entries that will be included, with toggles to exclude
4. Duration per clip: slider (0.5s — 3s, default 1s)
5. Generate button -> show progress indicator with % (FFmpeg reports progress)
6. Preview playback of result
7. Actions: Share / Save to Gallery / Discard

**State management:** Local to page (no need for provider — compilation is ephemeral)

### C3. Share + Export

**Files:** `lib/pages/compilation_page.dart` (extend)

- Use existing `share_plus` package to share generated MP4
- "Save to Gallery" via `media_scanner` (already a dependency) to make it visible in Photos
- Cleanup: delete temp segments after compilation, keep final output until explicitly discarded or app storage cleanup

---

## Work Stream D: Rewind Feature (#1)

> **Goal:** Surface a random past entry from the same calendar date (month + day) in previous years.

**New file:** `lib/widgets/rewind_card.dart`

### D1. Query + Display

**Files:** `lib/providers/entries_provider.dart`, `lib/pages/home_page.dart`

- Add `getEntriesForDayOfYear(int month, int day)` to `EntryDao` — returns entries where month/day match but year differs from current
- On home page, if matching entries exist, show a "Rewind" card:
  - Random entry from results
  - Shows: date, photo thumbnail, mood, text preview
  - Tap -> navigate to full entry detail
  - Swipe/tap "Show another" -> pick different random entry
- Only show if user has entries from a previous year on this date
- Respect the "This day" flashback concept already in `FlashbackManager` but make it more prominent

---

## Work Stream E: Onboarding (#12)

> **Goal:** First-time users understand the app and create their first entry within 2 minutes.

**New file:** `lib/pages/onboarding_page.dart`

### E1. Guided Onboarding Flow (3-4 screens)

**Screens:**
1. **Welcome** — app name, tagline ("Every day is worth remembering"), illustration
2. **Core concept** — "Capture a moment each day — photo, video, or just a few words"
3. **Privacy promise** — "Everything stays on your device. No accounts, no cloud, no tracking."
4. **Get started** — "Enable daily reminders?" toggle + "Create your first entry" CTA

**Implementation:**
- `PageView` with dot indicators
- Show only on first launch (`SharedPreferences` flag, replace current `dismissedNotificationOnboarding`)
- Final screen merges the existing notification permission flow
- Skip button on every screen
- On completion -> navigate to entry creation page

---

## Work Stream F: Year in Review (#11)

> **Goal:** Auto-generate a highlight reel summarizing the past year.

**Depends on:** C1-C3 (compilation pipeline)

### F1. Highlight Selection Algorithm

**File:** `lib/services/year_in_review_service.dart`

- Select ~30-60 entries from the year using:
  - At least 1 per month (if available)
  - Prefer entries with media over text-only
  - Prefer entries with positive mood scores
  - Weight toward entries with longer text (more effort = more meaningful)
  - Random sampling within weighted pool for variety

### F2. Year in Review Page

**New file:** `lib/pages/year_in_review_page.dart`

- Entry point: home page banner in January, or accessible year-round from stats page
- Shows: stat summary (total entries, streaks, mood graph) + generated compilation
- Uses compilation service (C1) with curated entry list
- Shareable output

---

## Work Stream G: UI/UX Polish (#13)

> **Goal:** Production-ready feel for daily personal use.

### G1. Micro-interactions
- Entry creation: subtle scale animation on save
- Calendar: smooth month transition (already partially exists)
- Mood selection: haptic feedback on iOS

### G2. Empty States
- Calendar with no entries: illustration + "Tap + to start"
- Gallery empty: similar treatment
- Stats with < 7 days of data: "Keep going! Stats unlock after a week"

### G3. Typography + Spacing Audit
- Consistent use of iOS system fonts on iOS
- Review padding/margins against iOS HIG spacing guidelines
- Ensure dark mode contrast ratios meet WCAG AA

### G4. App Icon + Launch Screen
- Replace default Flutter launch screen with branded splash
- Replace placeholder app icon (noted in issue comments as still default)

---

## Implementation Priority + Dependency Graph

```
Phase 1 (Video Foundation) — MUST DO FIRST
  A1 (DB migration) ──> A2 (video picker) ──> A3 (playback) ──> A4 (calendar indicators)

Phase 2 (Core 1SE) — unlocked by Phase 1
  A1-A3 ──> C1 (FFmpeg) ──> C2 (compilation UI) ──> C3 (share)
  A1 ──> B1 (Live Photo import) ──> B2 (Live Photo playback)
  (independent) D1 (Rewind)

Phase 3 (Engagement) — unlocked by Phase 2
  C1-C3 ──> F1-F2 (Year in Review)
  (independent) E1 (Onboarding)
  (independent) G1-G4 (Polish)
```

### Suggested PR Sequence

| PR | Scope | Depends on |
|----|-------|-----------|
| PR 1 | A1: DB migration v4 + model changes | — |
| PR 2 | A2 + A3: Video picker + playback | PR 1 |
| PR 3 | A4: Video indicators in calendar/gallery | PR 2 |
| PR 4 | D1: Rewind feature | — (independent) |
| PR 5 | E1: Onboarding flow | — (independent) |
| PR 6 | B1 + B2: Live Photo support | PR 2 |
| PR 7 | C1 + C2 + C3: Compilation pipeline + UI + share | PR 2 |
| PR 8 | F1 + F2: Year in Review | PR 7 |
| PR 9 | G1-G4: UI/UX polish pass | All above |

PRs 1-3 are sequential. PRs 4, 5 can be done in parallel at any time. PR 6 and PR 7 can be done in parallel after PR 2.

---

## Risks + Open Questions

1. **FFmpeg Kit on iOS simulators** — does not support arm64 simulators. All compilation testing needs a physical device. Mock FFmpeg in unit tests.
2. **App binary size** — `ffmpeg_kit_flutter_min` adds ~40-50MB. Acceptable for personal sideload, would be a concern for App Store.
3. **Video storage** — videos are much larger than images. Consider: max video duration (3s default), resolution cap (1080p), and periodic storage usage display in settings.
4. **Live Photo complexity** — PHPicker metadata access may require a platform channel. Consider the simpler "import as video" toggle for v1.
5. **AltStore refresh** — sideloaded apps expire every 7 days. This is an operational concern, not a code concern, but worth noting for daily-use viability.
