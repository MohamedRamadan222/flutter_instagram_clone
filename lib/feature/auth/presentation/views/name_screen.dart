import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/ig_button.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/password_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/widgets/already_have_an_account_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              'What\'s your name?',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Color(0xff121212),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: PlatformTextField(controller: _nameController),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: IGButton(
                text: 'Next',
                onPressed: () {
                  // Navigator to password screen.
                   Navigator.push(context, MaterialPageRoute(builder: (context){
                     return PasswordScreen();
                   }));
                },
              ),
            ),
            Spacer(),
            AlreadyHaveAnAccountSection(),
            SizedBox(height: 34.h),
          ],
        ),
      ),
    );
  }
}

class PlatformTextField extends StatelessWidget {
  final TextEditingController controller;

  const PlatformTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: GoogleFonts.outfit(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Full name',
        hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 14.sp),
        border: InputBorder.none,
      ),
    );
  }
}
