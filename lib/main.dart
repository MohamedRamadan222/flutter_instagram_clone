import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/router/app_router.dart';
import 'package:flutter_instagram_clone/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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