import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/data/backend_data_source.dart';
import 'package:flutter_instagram_clone/core/state/auth_store.dart';
import 'package:flutter_instagram_clone/core/utils/analytics_service.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // P7-3: attach the backend client once so analytics send best-effort;
    // no-op offline. Logged once per cold start.
    analytics.configure(ref.read(backendDataSourceProvider).client);
    analytics.log(
      AnalyticsEvent.appOpen,
      userId: DummyData.currentUser['username'] as String?,
    );
    // Boot gate (P4-1): after the branding delay, route by the persisted
    // session — the router's auth restore lands well within this window.
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      context.go(ref.read(authProvider) ? '/main' : '/login');
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