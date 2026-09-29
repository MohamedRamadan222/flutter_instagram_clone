# 03 — Data Contracts

Keep UI field names stable. Backend must return the same keys.

## Thread (`threads_dummy_data.dart:2`)

```
id: String (stable key for the threads-likes store),
username: String, profilePic: String(url), timeAgo: String (UI only),
text: String, likes: int, replies: int, reposts: int,
image: String? (nullable), isVerified: bool
```

Backend: `threads(id, user_id, text, image_url?, likes_count, replies_count, reposts_count, created_at)`.
`timeAgo` is derived client-side with `timeago` package. Source is `ThreadsDummyData.threads` (`DummyData.threads` alias removed in Phase 1).
`id` was added in Phase 2 to key the threads-likes store (previously `username|timeAgo`); backend `threads.id` maps 1:1.

## Post (`post_dummy_data.dart:2`)

```
id: String (stable key for stores), username, name, profilePic, location?,
isFollowing: bool,
media: [{type: image|video, url, reelId?}],
likes: int, caption: String, comments: int, reposts: int, shares: int,
timeAgo: String, isSponsored: bool, commentsData?: [{username, profilePic, comment, likes, time}]
```

Backend: `posts` + `post_media` + `comments`. `reelId` links a video post to `reels.id`.
`id` was added in Phase 2 to key the reaction/comment stores; backend `posts.id` maps 1:1.

## Story (`stories_dummy_data.dart:2`)

```
username, profileImage, isSeen: bool, stories: [{imageUrl}]
```

Backend: `stories(id, user_id, image_url, expires_at, seen_by[])`.

## Reel (`reel_dummy_data.dart:2`)

```
id, username, profilePic, videoUrl, caption, likes: String (display),
comments: String (display), audioTitle, isFollowing: bool
```

Note: likes/comments are display strings (`1.2M`). Backend should store ints and format client-side. Normalize in Phase 5.

## Suggested user (`dummy_suggested_user.dart:15`)

```
username, fullName, imageUrl, isFollowing (mutable)
```

Single source after Phase 1: class `DummySuggestedUser` via `dummySuggestedUsers` list. The `DummyData.suggestedUsers` map list was deleted (Phase 1, per the pick-one instruction below).

## New files to create (same style)

- `messages_dummy_data.dart`: `[{chatId, username, profilePic, lastMessage, timeAgo, unread: int, messages: [{fromMe: bool, text, time}]}]`
- `notifications_dummy_data.dart`: `[{type: like|follow|comment, username, profilePic, text, timeAgo, previewImage?}]`
