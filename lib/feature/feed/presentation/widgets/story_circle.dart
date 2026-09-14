import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryCircle extends StatelessWidget {
  final Map<String, dynamic> story;

  const StoryCircle({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    bool hasStory = story['hasStory'] ?? true;
    bool isSeen = story['isSeen'] ?? false;
    bool isLive = story['isLive'] ?? false;
    bool isUsernameYourStory = story['userName'] == 'Your story';

    return GestureDetector(
      onTap: () {
        // Nav to story view screen
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: (hasStory && !isSeen)
                        ? LinearGradient(
                            colors: [
                              Color(0xFFFEDA75),
                              Color(0xFFFA7E1E),
                              Color(0xFFD62976),
                              Color(0xFF962FBf),
                              Color(0xFF4F5ED5),
                            ],
                          )
                        : null,
                    border: (!hasStory || isSeen)
                        ? Border.all(color: Colors.grey.shade800, width: 1)
                        : null,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: CustomCircleAvatar(
                      imgUrl: story['profileImage'],
                      radius: 32.r,
                    ),
                  ),
                ),
                if (isUsernameYourStory && !hasStory)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Icon(Icons.add, color: Colors.black, size: 20),
                    ),
                  ),
                if (isLive)
                  Positioned(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'LIVE',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              story['username'],
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                color: isUsernameYourStory ? Colors.grey : Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
