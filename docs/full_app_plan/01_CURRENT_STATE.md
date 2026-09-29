# 01 — Current State Audit

Date: 2026-01-04. Based on direct file reads.

## Working

- `lib/feature/feed/presentation/views/home_screen.dart` — stories strip + posts + suggested + threads insertion, random indices, `AutomaticKeepAliveClientMixin`.
- `lib/core/utils/post_dummy_data.dart:1` — 8 posts with media, likes, comments, reposts.
- `lib/core/utils/stories_dummy_data.dart:1` — 8 users with story images.
- `lib/core/utils/reel_dummy_data.dart:1` — 6 reels (unused by UI yet, but `post_card.dart:246` links to them).
- `lib/core/utils/threads_dummy_data.dart:1` — 7 threads (new). Aliased as `DummyData.threads` in `lib/core/utils/dummy_data.dart:6`.
- `lib/feature/feed/presentation/widgets/threads_section.dart:3` — horizontal “Threads for you” cards.
- `lib/feature/feed/presentation/widgets/post_card.dart:19` — full post card: carousel, like, comment sheet trigger, repost, share, save, caption expand.
- `lib/feature/feed/presentation/widgets/story_circle.dart:6` — gradient ring, avatar, username.
- `lib/main_screen.dart:12` — 5-tab `PageView` + custom bottom nav.
- `lib/main.dart:10` — `ScreenUtilInit` + dark theme, home is `SplashScreen`.
- Auth screens exist (9 files in `lib/feature/auth/presentation/views/`) but not wired to `MainScreen`.

## Stubs / empty

- `lib/feature/feed/presentation/widgets/suggested_users_section.dart:13` — red `Container`, text only. Inserted in feed, breaks visuals.
- `lib/feature/search/presentation/views/search_screen.dart:10` — empty `Scaffold()`. `DummyData.exploreMedia` exists but unused.
- `lib/feature/message/presentation/views/messages_screen.dart:10` — empty `Scaffold()`. No messages dummy data exists.
- `lib/feature/profile/presentation/views/profile_screen.dart:10` — empty `AppBar` only.
- `lib/feature/profile/presentation/views/user_profile_screen.dart:12` — empty `Scaffold()`, but `post_card.dart:127` navigates to it.
- `lib/feature/reels/presentation/views/reels_screen.dart:12` — empty `Scaffold()`, but `post_card.dart:246` navigates to it.
- `lib/feature/comments/presentation/views/comments_screen.dart:11` — empty `Scaffold()`, but `post_card.dart:424` opens it. `commentsData` exists in dummy posts.

## Known bugs (fix in Phase 0)

1. `lib/feature/feed/presentation/widgets/post_card.dart:237` — `media['0']['type']` should be `media[0]['type']`. Video-tap path always fails.
2. `lib/feature/feed/presentation/widgets/post_card.dart:599` — expand label shows `'true'`, should be `'more'`.
3. Dead taps: `home_screen.dart:56` (add), `home_screen.dart:72` (likes), `story_circle.dart:19` (story open). Need target screens.
4. `pubspec.yaml:30` has no `flutter_riverpod`/`flutter_bloc`, no `image_picker`, no backend, no push. Required before create-flows and backend phases.

## Missing data files

- `messages_dummy_data.dart` — chats + messages.
- `notifications_dummy_data.dart` — likes/follows/activity.
- Backend mapping for all dummy shapes (see `03_DATA_CONTRACTS.md`).
