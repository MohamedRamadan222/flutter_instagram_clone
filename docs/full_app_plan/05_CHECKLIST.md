# 05 — Checklist

Copy tick state here. Source of tasks is `02_PHASES.md`.

## Phase 0 — Stabilize

- [x] P0-1 video-tap index fix
- [x] P0-2 more/less label fix
- [x] P0-3 feed insertion math verified
- [x] P0-4 analyze clean

## Phase 1 — UI with dummy

- [x] P1-1 suggested users
- [x] P1-2 comments sheet
- [x] P1-3 reels player
- [x] P1-4 search + explore grid
- [x] P1-5 messages (dummy + list + detail)
- [x] P1-6 profile + user profile
- [x] P1-7 story viewer
- [x] P1-8 activity/notifications

## Phase 2 — Local state

- [x] P2-1 state package added
- [x] P2-2 stores created
- [x] P2-3 post card migrated
- [x] P2-4 follow sync verified

## Phase 3 — Create flows

- [x] P3-1 media deps (image_picker, video_thumbnail, permission_handler)
- [x] P3-2 new post (multi-image → caption → top of feed)
- [x] P3-3 new story (gallery → your-story ring)
- [x] P3-4 new reel (video → thumbnail → top of reels)
- [x] P3-5 add button wired (feed + reels tab)

## Phase 4 — Auth + nav

- [x] P4-1 splash→auth→main + logout (profile app bar)
- [x] P4-2 router (go_router: /splash /login /signup/* /main /user/:id /reels /comments /story)
- [x] P4-3 session persisted (shared_preferences + auth store)

## Phase 5 — Backend

- [x] P5-1 provider chosen + noted (`06_BACKEND.md`: Supabase)
- [x] P5-2 schema created (`supabase_schema.sql`: 14 tables + buckets + RLS + realtime)
- [x] P5-3 repos + pagination + offline cache (feed pages, stories, reels, comments, writes)
- [ ] P5-4 push — runbook in `06_BACKEND.md`; blocked on a Firebase project
- [x] P5-5 dummy removed from UI — data layer primary; dummy files remain as
      offline seed; threads/notifications/messages hydration is a follow-up

## Phase 6 — Quality

- [x] P6-1 states (loading/empty/error)
- [x] P6-2 perf pass
- [x] P6-3 permissions + autoplay policy
- [x] P6-4 tests pass

## Phase 7 — Release

- [x] P7-1 icon/splash/version
- [x] P7-2 signing + perms
- [x] P7-3 crashlytics + analytics
- [x] P7-4 closed test → production (AAB verified + `07_RELEASE_RUNBOOK.md`; console upload is human)
