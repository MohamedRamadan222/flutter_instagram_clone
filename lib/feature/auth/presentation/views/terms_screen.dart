import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/add_profile_picture_screen.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/widgets/already_have_an_account_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/widgets/ig_button.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                "Agree to Instagram's Terms and policies",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13.sp,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'People who use our service may have uploaded your contact information to Instagram. ',
                    ),
                    TextSpan(text: 'Learn More\n\n'),
                    TextSpan(
                      text:
                          'By tapping I Agree, you agree to create an account and to Instagram\'s ',
                    ),
                    TextSpan(text: 'Terms, Privacy Policy '),
                    TextSpan(text: 'and '),
                    TextSpan(text: 'Cookies Policy.\n\n'),
                    TextSpan(
                      text:
                          'The Privacy Policy describes the ways we can use the information we collect when you create an account. For example, we use this information to provide, personalize and improve our products, including ads.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: IGButton(
                  text: 'I agree',
                  onPressed: () {
                    // Navigate to add profile picture screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddProfilePictureScreen(),
                      ),
                    );
                  },
                ),
              ),
              Spacer(),
              AlreadyHaveAnAccountSection(),
            ],
          ),
        ),
      ),
    );
  }
}
