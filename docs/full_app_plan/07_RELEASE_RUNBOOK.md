# 07 — Release runbook (P7-4, Android closed test)

## Verified artifact (agent-built, this repo)

- `build/app/outputs/bundle/release/app-release.aab` (63.7MB), `version:
  1.0.0+1`, package `com.example.flutter_instagram_clone`
- Signed with **debug keys** — good for closed-test installs, NOT for
  production. Production needs the keystore steps in
  `android/app/build.gradle.kts` (human, secrets stay out of git).
- Release build passes with Sentry v9 + analytics wired (P7-3). Env note:
  this machine needs the `platforms/android-37 → android-37.0` symlink for
  `permission_handler_android` compileSdk 37.

## Human: closed track (Play Console)

1. Create app, upload the AAB to the **closed** track (not production).
2. Add tester emails / Google Group; testers open the opt-in link.
3. Testers install on real devices and exercise: cold start, login/signup,
   feed scroll, like/follow/post/reel create, gallery permission
   allow + deny paths (P6-3), airplane-mode cache (P5-3).
4. Crash-fix loop: reproduce with a Sentry-DSN build
   (`--dart-define=SENTRY_DSN=...`), confirm events in Supabase
   `analytics_events`, fix, rebuild AAB, re-upload.

## Human: production promotion

1. Create the release keystore, add `android/key.properties`, switch
   `build.gradle.kts` to the release signing config, rebuild AAB.
2. Bump `pubspec.yaml` version (`1.0.0+1` → `1.0.1+2` or `1.1.0+2`).
3. Promote closed → production with staged rollout (e.g. 10% → 50% →
   100%), monitor Sentry + analytics before each step up.

## Store listing (human copy needed)

- Name, short + full description, category, contact email.
- Graphics: screenshots (phone 2+, 7-inch + 10-inch tablet if claimed),
  1024px feature graphic, launcher icon already in repo (P7-1).
- Data safety form: photos/videos (gallery picks), network (Supabase
  backend), no contacts/location collected.
- Privacy policy URL (required): publish one before the production review.
- Content rating questionnaire (social app, user-generated content).

## Deferred (not this pass)

- iOS: display name + photo-library usage strings, IPA/TestFlight.
- Push (P5-4): needs a Firebase project; add FCM + `POST_NOTIFICATIONS`
  runtime prompt when it lands.
