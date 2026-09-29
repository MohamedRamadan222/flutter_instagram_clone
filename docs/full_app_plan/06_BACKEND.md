# 06 — Backend: Supabase

Decision + runbook for Phase 5. Date: 2026-09-29.

## 1. Choice: Supabase (not Firebase)

| Criterion | Supabase | Firebase/Firestore |
|---|---|---|
| Data model | Postgres — relational, matches `03_DATA_CONTRACTS.md` 1:1 | documents; joins/aggregates are convoluted |
| SDK | pure Dart (`supabase_flutter`) — works on Linux desktop, no platform files | `flutterfire configure` + `google-services.json` per platform |
| Schema as code | plain SQL in this folder, checkable | console or security rules |
| Realtime | websocket streams from any table | Firestore listeners (fine too) |
| Pagination | PostgREST `range()` | `orderBy`+`limit` cursor dance |
| Offline cache | state layer already caches JSON page-by-page | Firestore disk cache |

Firebase remains the plan for push (FCM) — see §4 (P5-4, blocked on credentials).

## 2. Runbook (one time)

1. Create a free project at supabase.com (any region).
2. SQL editor → run `supabase_schema.sql` (same folder). This creates all tables,
   storage buckets, RLS policies and realtime publications.
3. Project Settings → API: copy the **Project URL** and the **anon public key**.
4. Run the app with the backend enabled:

```bash
flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co \
            --dart-define=SUPABASE_ANON_KEY=eyJ...
```

5. Without the defines the app stays on dummy data (`AppConfig.hasBackend`),
   so the demo never breaks.

## 3. How the app consumes it (P5-3)

- `BackendDataSource` (`lib/core/data/backend_data_source.dart`) maps DB rows to
  the exact map keys in `03_DATA_CONTRACTS.md`, so widget code barely changes.
- Feed: page size 15, PostgREST `range()`; pull-to-refresh reloads page 1,
  scrolling near the bottom loads the next page (`FeedPostsStore.refresh`/
  `loadMore`).
- Offline: every successful read writes a `LocalCache` entry (shared_preferences);
  on any failure the repo serves the cache, so airplane mode shows the last
  data (acceptance: "airplane mode shows cache").
- Stores (`feed/stories/reels/posts-reactions/follow/comments`) keep their
  session state and push writes to Supabase best-effort; dummy seeds remain the
  fallback when the backend is absent.
- Two-device sync: `posts`, `post_likes`, `saves`, `comments`, `follows` are on
  the realtime publication — pull-to-refresh picks up other devices' writes.
  (A live subscription channel is a later enhancement.)

## 4. Push notifications (P5-4 — runbook only, blocked)

FCM needs a Firebase project (`google-services.json` / APNs keys) that does not
exist yet; adding the deps now would break Android builds. To finish P5-4:

1. Create a Firebase project, add Android app (package id from
   `android/app/build.gradle`), download `google-services.json` into
   `android/app/`.
2. `flutter pub add firebase_core firebase_messaging`
3. Apply `com.google.gms.google-services` in `android/app/build.gradle`.
4. Wire `FirebaseMessaging.onMessageOpenedApp`/`onMessage` → route to
   notifications screen; reuse `notifications` table rows as the payload.

## 5. Known limitations (tracked)

- P5-4 blocked (above).
- Threads / notifications / messages screens still read dummy constants;
  hydration for those stores is a follow-up.
- Reposts are session-local (no `reposts` table yet).
- RLS grants are open to the `anon` role for demo purposes — lock down with
  Supabase Auth before any real release.
- Story "seen" state is client-side only.