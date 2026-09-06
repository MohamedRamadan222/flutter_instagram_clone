import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login screen after 2.5 sec
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Centered Instagram logo
            Center(
              child: SizedBox(
                height: 120.h,
                width: 120.w,
                child: Image.asset(
                  'assets/images/ig_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // form meta
            Positioned(
              bottom: 30,
              right: 0,
              left: 0,
              child: Center(
                child: SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: Image.asset(
                    'assets/images/meta.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
