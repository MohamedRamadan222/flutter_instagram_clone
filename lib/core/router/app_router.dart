import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/state/auth_store.dart';
import 'package:flutter_instagram_clone/core/state/feed_posts_store.dart';
import 'package:flutter_instagram_clone/core/state/reels_store.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/add_profile_picture_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/birthday_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/follow_suggestions_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/login_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/name_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/password_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/signup_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/splash_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/terms_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/username_setup_screen.dart';
import 'package:flutter_instagram_clone/feature/comments/presentation/views/comments_screen.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/views/story_view_screen.dart';
import 'package:flutter_instagram_clone/feature/profile/presentation/views/user_profile_screen.dart';
import 'package:flutter_instagram_clone/feature/reels/presentation/views/reels_screen.dart';
import 'package:flutter_instagram_clone/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Unrecognized usernames still render a profile page with dummy content.
Map<String, dynamic> _userFallback(String username) => {
      'username': username,
      'name': username,
      'profilePic':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=400&auto=format&fit=crop',
      'bio': '',
      'followers': 0,
      'following': 0,
      'isCurrent': false,
      'gender': '',
    };

/// Pure guard rule used by the router (P4-1): logged-out users may only be
/// on `/splash` or the auth flow; logged-in users are kept off it. Returns
/// the redirect target, or null to stay put.
String? authRedirect(String matchedLocation, bool loggedIn) {
  final isAuthRoute = matchedLocation == '/login' ||
      matchedLocation.startsWith('/signup');
  if (matchedLocation == '/splash') return null; // splash decides entry point
  if (!loggedIn && !isAuthRoute) return '/login';
  if (loggedIn && isAuthRoute) return '/main';
  return null;
}

/// App-wide navigation (P4-2).
///
/// Routes: `/splash`, `/login`, `/signup` + sub-steps, `/main`, `/user/:id`,
/// `/reels`, `/comments/:postId`, `/story`. A redirect guard keeps logged-out
/// users away from the tabs and logged-in users away from the auth flow; the
/// splash screen chooses the boot route from the persisted session (P4-1).
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) =>
        authRedirect(state.matchedLocation, ref.read(authProvider)),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
        routes: [
          GoRoute(
            path: 'name',
            builder: (context, state) => const NameScreen(),
          ),
          GoRoute(
            path: 'password',
            builder: (context, state) => const PasswordScreen(),
          ),
          GoRoute(
            path: 'birthday',
            builder: (context, state) => const BirthdayScreen(),
          ),
          GoRoute(
            path: 'username',
            builder: (context, state) => const UsernameSetupScreen(),
          ),
          GoRoute(
            path: 'terms',
            builder: (context, state) => const TermsScreen(),
          ),
          GoRoute(
            path: 'profile-picture',
            builder: (context, state) => const AddProfilePictureScreen(),
          ),
          GoRoute(
            path: 'follow-suggestions',
            builder: (context, state) => const FollowSuggestionsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/user/:username',
        builder: (context, state) {
          final username = state.pathParameters['username'] ?? '';
          if (username.isEmpty) return const MainScreen();
          final user = DummyData.accounts.firstWhere(
            (a) => a['username'] == username,
            orElse: () => _userFallback(username),
          );
          return UserProfileScreen(user: user);
        },
      ),
      GoRoute(
        path: '/reels',
        builder: (context, state) {
          final raw =
              int.tryParse(state.uri.queryParameters['index'] ?? '') ?? 0;
          final reels = ref.read(reelsProvider);
          final index = reels.isEmpty
              ? 0
              : raw.clamp(0, reels.length - 1);
          return ReelsScreen(initialIndex: index);
        },
      ),
      GoRoute(
        path: '/comments/:postId',
        builder: (context, state) {
          final postId = state.pathParameters['postId'] ?? '';
          if (postId.isEmpty) return const MainScreen();
          final post = ref.read(feedPostsProvider).firstWhere(
                (p) => p['id'] == postId,
                orElse: () => <String, dynamic>{
                  'id': postId,
                  'commentsData': <Map<String, dynamic>>[],
                },
              );
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text('Comments'),
            ),
            body: CommentsScreen(post: post, asPage: true),
          );
        },
      ),
      GoRoute(
        path: '/story',
        builder: (context, state) {
          final user = state.uri.queryParameters['user'];
          return StoryViewScreen(initialUser: user);
        },
      ),
    ],
  );
  ref.listen(authProvider, (_, __) => router.refresh());
  return router;
});