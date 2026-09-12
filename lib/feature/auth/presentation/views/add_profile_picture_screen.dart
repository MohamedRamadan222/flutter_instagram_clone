import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/ig_button.dart';
import 'package:flutter_instagram_clone/feature/auth/presentation/views/follow_suggestions_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProfilePictureScreen extends StatelessWidget {
  const AddProfilePictureScreen({super.key});

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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'Add a profile picture',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'Add a profile picture so friends know it\'s you. Everyone well be able to see your picture.',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 100.sp,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Divider(color: Colors.white.withValues(alpha: 0.3)),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                width: double.infinity,
                child: IGButton(
                  text: "Add picture",
                  onPressed: () {
                    // Add Picture functionality
                  },
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff201d1d),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Navigator to follow suggestions screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FollowSuggestionsScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
