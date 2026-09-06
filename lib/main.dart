import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/theme/app_theme.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Instagram Clone',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: SplashScreen(),
        );
      },
    );
  }
}
