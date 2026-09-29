# 02 — Phases

Work in order. Each phase lists goal, tasks, acceptance.

## Phase 0 — Stabilize (0.5 day)

Goal: feed runs with zero analyze issues and no crashes.

- [ ] P0-1 Fix `post_card.dart:237` video-tap index (`media[0]` + length/type guards).
- [ ] P0-2 Fix `post_card.dart:599` more/less label.
- [ ] P0-3 Verify `home_screen` insertion math (`_totalItems`, distinct indices, `childCount`, `postIndex` guard, `super.build`).
- [ ] P0-4 `dart analyze` clean on touched files.

Accept: tap first post video (if any), expand long caption, scroll full feed, no red screen, analyze clean.

## Phase 1 — Finish UI with dummy data (3–4 days)

Goal: no empty scaffolds, no color stubs.

- [ ] P1-1 Suggested users: horizontal cards from `dummy_suggested_user.dart:15`, avatar + name + Follow button toggling local state. Replace red stub in `suggested_users_section.dart`.
- [ ] P1-2 Comments sheet: list `post['commentsData']` + input row (local insert). Wire `comments_screen.dart`.
- [ ] P1-3 Reels: vertical `PageView`, `video_player` + `visibility_detector`, like/comment/share overlay, start at `initialIndex`. Wire `reels_screen.dart`.
- [ ] P1-4 Search: search bar (filter usernames) + 3-col `exploreMedia` grid with image/video badge. Wire `search_screen.dart`.
- [ ] P1-5 Messages: `messages_dummy_data.dart` (new, same style as `threads_dummy_data.dart`), chat list + detail bubble UI. Wire `messages_screen.dart`.
- [ ] P1-6 Profile + user profile: header (avatar, counts, bio, Follow/Message), highlights row, 3-col posts grid from `savedPosts`, tabs (posts/reels/tagged static first). Wire `profile_screen.dart`, `user_profile_screen.dart`.
- [ ] P1-7 Story viewer: full-screen `PageView` of `stories`, progress bar, tap left/right, mark seen. Wire `story_circle.dart:19`.
- [ ] P1-8 Activity: `notifications_dummy_data.dart` (new), list grouped by Today/Week. Wire `home_screen` heart button.

Accept: all 5 tabs render real content, every button in feed opens something, no `Scaffold()` empty page remains.

## Phase 2 — Local state (2 days)

Goal: actions persist across screens during session.

- [ ] P2-1 Add state management: `flutter_riverpod` (recommended) + `timeago`.
- [ ] P2-2 Stores: feed posts (like/save/repost counts), follow map, threads likes, reels likes, comments per post.
- [ ] P2-3 Replace scattered `setState` counters in `post_card.dart` with store calls.
- [ ] P2-4 Follow buttons everywhere reflect same state.

Accept: like in feed → same count in comments sheet; follow in suggested → same in profile.

## Phase 3 — Create flows (2–3 days)

Goal: user can add content locally.

- [ ] P3-1 Deps: `image_picker`, `video_thumbnail`, `permission_handler`.
- [ ] P3-2 New post: pick multi-image → caption → insert at top of feed.
- [ ] P3-3 New story: pick image → insert into stories strip.
- [ ] P3-4 New reel: pick video → thumbnail → insert into reels.
- [ ] P3-5 Wire `home_screen` add button to this flow.

Accept: created post/story/reel visible immediately without restart.

## Phase 4 — Auth + navigation (2 days)

Goal: real entry flow.

- [ ] P4-1 Wire `SplashScreen` → login/signup → `MainScreen`, guard (logged out cannot reach tabs), logout in profile.
- [ ] P4-2 Add router (`go_router`): `/splash`, `/auth/*`, `/main`, `/user/:id`, `/reels`, `/comments`, `/story`.
- [ ] P4-3 Persist session locally (`shared_preferences` or `hive`).

Accept: cold start respects session, back button behaves, deep link to user works.

## Phase 5 — Backend (1–2 weeks)

Goal: dummy → persistent backend.

- [ ] P5-1 Choose Firebase or Supabase and document in this folder.
- [ ] P5-2 Tables/collections per `03_DATA_CONTRACTS.md`: users, posts, stories, reels, threads, comments, follows, likes, saves, messages, notifications + Storage buckets.
- [ ] P5-3 Repos with pagination (10–15 per page), pull-to-refresh, offline cache.
- [ ] P5-4 Push notifications (FCM) for likes/follows/messages.
- [ ] P5-5 Remove `const` dummy imports from UI; keep dummy files only for previews/tests.

Accept: two devices see same data, restart keeps data, airplane mode shows cache.

## Phase 6 — Quality (1 week)

Goal: feels like Instagram, not a demo.

- [ ] P6-1 Empty/loading/error states everywhere + shimmer placeholders.
- [ ] P6-2 Image/video caching policy, low-end device scroll test, reduce rebuilds.
- [ ] P6-3 Permissions handling, video mute/autoplay policy.
- [ ] P6-4 Widget tests for insertion math, like/follow stores, time formatting.

Accept: no jank on scroll, no crash on bad URL, tests pass.

## Phase 7 — Release (3–5 days)

Goal: store-ready.

- [ ] P7-1 Icon, splash, name, `version: 1.0.0+1` bump plan.
- [ ] P7-2 Android signing + `INTERNET`/`READ_MEDIA` perms, iOS display name + photo-library usage strings.
- [ ] P7-3 Crashlytics + analytics events (open app, like, post, follow).
- [ ] P7-4 Closed-test track, fix crashes, then production.

Accept: signed AAB + IPA install on real devices, store listing ready.
