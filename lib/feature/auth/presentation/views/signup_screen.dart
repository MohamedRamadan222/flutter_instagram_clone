import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/ig_button.dart';
import 'package:flutter_instagram_clone/core/common/widgets/section_title.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/name_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/already_have_an_account_section.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController controller = TextEditingController();
  bool isEmail = false;

  @override
  Widget build(BuildContext context) {
    final title = isEmail
        ? "What's your email address?"
        : "What's your mobile number?";
    final subTitle = isEmail
        ? "Enter your email address at which you can be contacted. No one will see this on your profile."
        : "Enter your mobile number at which you can be contacted. No one will see this on your profile.";
    final hint = isEmail ? "Email address" : "Mobile number";
    final switchText = isEmail
        ? "Sign up with phone number"
        : "Sign up with email address";
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            // title
            SectionTitle(title: title, subTitle: subTitle),

            SizedBox(height: 20.h),

            // Input Field
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Color(0xff121212),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: TextField(
                controller: controller,
                keyboardType: isEmail
                    ? TextInputType.emailAddress
                    : TextInputType.phone,
                style: GoogleFonts.outfit(color: Colors.white),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.outfit(
                    color: Colors.grey,
                    fontSize: 11.sp,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 6.h),

            if (!isEmail)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'You may receive WhatsApp and SMS notification from us.',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      minimumSize: Size(0, 30.h),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Learn more',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: IGButton(
                text: 'Next',
                onPressed: () {
                  // Navigator to name screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return NameScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),

            // switch option
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  splashFactory: NoSplash.splashFactory, // removes ripple
                ),
                onPressed: () {
                  setState(() {
                    isEmail = !isEmail;
                    controller.clear();
                  });
                },
                child: Text(
                  switchText,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
