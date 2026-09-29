# Instagram Clone — Full App Completion Plan

This folder is the source of truth for finishing the app and shipping it.

## Contents

1. `01_CURRENT_STATE.md` — what exists, what is stubbed, known bugs (with file:line).
2. `02_PHASES.md` — 8 phases from stabilize to store release.
3. `03_DATA_CONTRACTS.md` — dummy-data shapes and backend mapping.
4. `04_INSTRUCTIONS.md` — how to execute each phase, conventions, verification.
5. `05_CHECKLIST.md` — tick-box tracker. Update it as you go.

## How to use

- Work one phase at a time, in order. Do not skip Phase 0.
- Each phase has: goal, tasks, acceptance criteria, verification command.
- Update `05_CHECKLIST.md` when a task is done.
- Run `dart analyze` after every phase. Zero issues before moving on.

## Current stack

- UI: Flutter + `google_fonts`, `flutter_screenutil`, `cached_network_image`, `shimmer`, `video_player`, `visibility_detector` (`pubspec.yaml:30`).
- No state management, no backend, no image-picker yet. All data is `const` dummy in `lib/core/utils/`.

## Definition of done (full app)

- No empty `Scaffold()`, no red/orange stub sections.
- All tabs in `lib/main_screen.dart:50` work: Home, Reels, Messages, Search, Profile.
- Auth wired: `SplashScreen` → login/signup → `MainScreen` with guard + logout.
- Create post/story/reel works end-to-end.
- Backend persistence + pagination + offline cache.
- `dart analyze` clean, tested on real Android + iOS, signed release builds.
