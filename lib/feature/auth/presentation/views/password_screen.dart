import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/ig_button.dart';
import 'package:flutter_instagram_clone/core/common/widgets/section_title.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/birthday_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _savePasswordState = true;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            SectionTitle(
              title: 'Create a password',
              subTitle:
                  'Create a password with at least 6 letters or numbers. it should be something others can\'t guess.',
            ),
            SizedBox(height: 20.h),
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Color(0xff2a2a2a),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      style: GoogleFonts.outfit(color: Colors.white),
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.outfit(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: Checkbox.adaptive(
                    value: _savePasswordState,
                    activeColor: AppColors.blue,
                    checkColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade600, width: 2),
                    onChanged: (value) {
                      setState(() {
                        _savePasswordState = value ?? true;
                      });
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Remember login info',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Learn more',
                    style: GoogleFonts.outfit(
                      color: AppColors.blue,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: IGButton(
                text: 'Next',
                onPressed: () {
                  // Navigate to birthday screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return BirthdayScreen();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
