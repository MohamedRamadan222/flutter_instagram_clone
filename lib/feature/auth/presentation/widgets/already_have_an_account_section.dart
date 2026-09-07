import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AlreadyHaveAnAccountSection extends StatelessWidget {
  const AlreadyHaveAnAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(
          'I already have an account',
          style: GoogleFonts.outfit(
            color: AppColors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
