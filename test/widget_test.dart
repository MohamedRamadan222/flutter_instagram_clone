// Smoke tests for the boot flow, the auth guard and session persistence
// (P4-1, P4-2, P4-3). Deeper tests (insertion math, stores, time
// formatting) are Phase 6 (P6-4).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_instagram_clone/core/router/app_router.dart';
import 'package:flutter_instagram_clone/core/state/auth_store.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/login_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/splash_screen.dart';
import 'package:flutter_instagram_clone/main.dart';

void main() {
  testWidgets('app boots from splash into login', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    // splash screen shows first
    expect(find.byType(SplashScreen), findsOneWidget);

    // after the 2.5s splash delay the login screen is routed to
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  group('auth guard', () {
    test('logged-out users may only see splash or the auth flow', () {
      expect(authRedirect('/splash', false), isNull);
      expect(authRedirect('/login', false), isNull);
      expect(authRedirect('/signup/name', false), isNull);
      expect(authRedirect('/main', false), '/login');
      expect(authRedirect('/user/omar.khaled', false), '/login');
      expect(authRedirect('/reels', false), '/login');
    });

    test('logged-in users are kept off the auth flow', () {
      expect(authRedirect('/login', true), '/main');
      expect(authRedirect('/signup', true), '/main');
      expect(authRedirect('/main', true), isNull);
      expect(authRedirect('/user/omar.khaled', true), isNull);
      expect(authRedirect('/splash', true), isNull);
    });
  });

  test('a persisted session is restored into the auth store', () async {
    SharedPreferences.setMockInitialValues({'auth_logged_in': true});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // reading the provider starts the async restore
    expect(container.read(authProvider), isFalse);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(container.read(authProvider), isTrue);
    // with the session restored the guard lets /main through
    expect(authRedirect('/main', container.read(authProvider)), isNull);
  });
}