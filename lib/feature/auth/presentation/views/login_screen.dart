import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/signup_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/widgets/ig_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            // logo
            Image.asset('assets/images/ig_logo.png', width: 60.w, height: 60.h),
            SizedBox(height: 80.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _inputField('UserName, email address or mobile number'),
                  SizedBox(height: 12.h),
                  _inputField('Password', isPassword: true),
                  SizedBox(height: 18.h),
                  SizedBox(
                    width: double.infinity,
                    child: IGButton(
                      text: 'Login',
                      onPressed: () {
                        // Navigate to Main Screen
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Forgotten Password',
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            // Sign up
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  side: BorderSide(color: AppColors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(28.r),
                  ),
                ),
                onPressed: () {
                  // Navigate to sign up screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return SignupScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  'Create new account',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hint, {bool isPassword = false}) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        obscureText: isPassword,
        style: GoogleFonts.outfit(color: Colors.white, fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(
            color: Colors.grey.shade700,
            fontSize: 12.sp,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
