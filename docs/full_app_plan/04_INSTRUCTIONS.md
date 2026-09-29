# 04 — Instructions

## Working rules

1. One phase at a time. Finish acceptance before next phase.
2. Prefer editing existing files over creating new ones. New files only for new screens/data (e.g. `messages_dummy_data.dart`).
3. Keep dark theme: black backgrounds, `GoogleFonts.outfit`, `flutter_screenutil` (`.w/.h/.sp`), `CachedNetworkImage` with shimmer placeholder.
4. Never leave `onPressed: () {}` empty — either wire it or remove the button.
5. Reuse avatars/URLs already in dummy files for consistency.

## Per-task loop

1. Read the target file fully before editing.
2. Make the smallest change that meets acceptance.
3. Run: `dart analyze <touched files>` — must be clean.
4. Manual check on the phase's acceptance line (scroll, tap, rotate, bad URL).
5. Tick the box in `05_CHECKLIST.md`.

## Commands

```bash
dart analyze lib/core/utils/threads_dummy_data.dart lib/feature/feed/presentation/views/home_screen.dart lib/feature/feed/presentation/widgets/threads_section.dart
flutter run
flutter test
```

## Adding a dependency

1. Add to `pubspec.yaml`, run `flutter pub get`.
2. Note it in `02_PHASES.md` if it changes the plan.
3. Required upcoming: `flutter_riverpod`, `timeago`, `image_picker`, `go_router`, `shared_preferences` (or `hive`), then backend SDK.

## Do not

- Do not change field names in dummy maps without updating `03_DATA_CONTRACTS.md` and all usages (grep first).
- Do not keep two suggested-user sources after Phase 1.
- Do not start backend (Phase 5) before Phase 2 state stores exist — you will rewrite twice.
