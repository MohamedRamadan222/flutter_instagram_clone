import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class IGButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const IGButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.height = 40.0,
    this.fontSize = 14,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isPrimary
              ? (isDisabled
                    ? AppColors.blue.withValues(alpha: 0.4)
                    : AppColors.blue)
              : Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(32.r),
          ),
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 16.h,
                width: 16.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.outfit(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
