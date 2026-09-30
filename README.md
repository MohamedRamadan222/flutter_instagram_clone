# Instagram Clone (Flutter)

A full Instagram-style app built with Flutter: feed with stories, reels,
explore, messages, posting flows, auth-gated navigation, Supabase backend
with offline cache, and release-ready quality passes (image-cache policy,
permissions handling, crash reporting, analytics).

## Features

- **Feed** — posts with multi-media carousel, like/save/repost/share,
  comments, suggested-users + threads inserts, story strip + story viewer,
  pull-to-refresh with paginated backend pages
- **Reels** — vertical pager, lazy video init, muted autoplay, per-player
  mute toggle, like/comment/share overlays
- **Explore & search** — username search + 3-column media grid
- **Messages** — chat list + detail bubbles
- **Profile** — header, highlights, posts/reels/tagged tabs, follow/message
- **Create flows** — new post (multi-image), story, reel (video + thumbnail)
- **Auth** — splash → login/signup → main, persisted session, logout
- **Offline-first** — Supabase data layer with local JSON cache fallback
- **Quality** — shimmer/empty/error states, bounded image decoding,
  permission rationale + Settings deep-link, muted-autoplay video policy

## Tech stack

Flutter 3.47 / Dart 3.13 · Riverpod · go_router · Supabase ·
`cached_network_image` · `video_player` + `visibility_detector` ·
`image_picker` + `permission_handler` · `sentry_flutter` · ScreenUtil ·
Google Fonts.

## Getting started

```bash
flutter pub get
flutter run                     # your device
flutter run -d chrome --web-browser-flag="--window-size=412,915"  # phone-size web
```

Backend (optional — app runs on dummy data offline without it):

```bash
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

Crash reporting (optional — no-op without it):

```bash
flutter run --dart-define=SENTRY_DSN=...
```

## Verify

```bash
dart analyze
flutter test
flutter build appbundle --release   # Android closed-test artifact
```

## Project layout

```
lib/
  core/
    config/app_config.dart        # backend + env flags
    data/backend_data_source.dart # Supabase repos, pagination, offline cache
    router/app_router.dart        # /splash /login /signup/* /main /user/:id ...
    state/                        # Riverpod stores (feed, follow, likes, ...)
    utils/                        # image_cache, autoplay + permission policies, analytics
    common/widgets/               # avatar, buttons, feed state widgets
  feature/
    auth/ feed/ reels/ search/ message/ profile/ comments/ create/
  main.dart                       # Sentry init + ProviderScope boot
docs/full_app_plan/               # phased plan, checklist, backend + release runbooks
```

## Docs

- `docs/full_app_plan/05_CHECKLIST.md` — phase tracker (source of truth)
- `docs/full_app_plan/06_BACKEND.md` — Supabase setup + FCM runbook
- `docs/full_app_plan/07_RELEASE_RUNBOOK.md` — signing, closed test, listing
- `docs/full_app_plan/supabase_schema.sql` — 14 tables + analytics events

## Status

Phases 0–7 complete. Open items: push notifications (needs a Firebase
project), Play Console upload + production keystore (human steps in the
release runbook), iOS TestFlight pass.
