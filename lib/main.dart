import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/router/app_router.dart';
import 'package:flutter_instagram_clone/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// P7-3: crash reporting only. Human step: create a Sentry Flutter project,
// then pass --dart-define=SENTRY_DSN=<your DSN> at build/run time
// (e.g. `flutter run --dart-define=SENTRY_DSN=...`). Empty DSN (default)
// runs the app with no Sentry so local dev, offline, and widget tests boot
// unchanged (splash -> auth -> main) with default Flutter error handling.
Future<void> main() async {
  const sentryDsn = String.fromEnvironment('SENTRY_DSN');
  if (sentryDsn.isEmpty) {
    runApp(const ProviderScope(child: MyApp()));
    return;
  }
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsn;
      options.tracesSampleRate = 0.2;
    },
    // Sentry installs FlutterError.onError / PlatformDispatcher.onError
    // handlers and forwards to any previous handler, so existing error
    // passthrough is preserved; the boot tree below is unchanged.
    appRunner: () => runApp(const ProviderScope(child: MyApp())),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Instagram Clone',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: ref.watch(routerProvider),
        );
      },
    );
  }
}