// Smoke test: the app boots into the splash screen and then reaches login.
// Deeper tests (insertion math, stores, time formatting) are Phase 6 (P6-4).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_instagram_clone/feature/auth/presentation/views/login_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/splash_screen.dart';
import 'package:flutter_instagram_clone/main.dart';

void main() {
  testWidgets('app boots from splash into login', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );

    // splash screen shows first
    expect(find.byType(SplashScreen), findsOneWidget);

    // after the 2.5s splash delay the login screen is pushed
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}