import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/ig_button.dart';
import 'package:flutter_instagram_clone/core/common/widgets/section_title.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_suggested_user.dart';
import 'package:flutter_instagram_clone/main_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/common/widgets/custom_circle_avatar.dart';
import '../../../../core/common/widgets/ig_follow_button.dart';

class FollowSuggestionsScreen extends StatefulWidget {
  const FollowSuggestionsScreen({super.key});

  @override
  State<FollowSuggestionsScreen> createState() =>
      _FollowSuggestionsScreenState();
}

class _FollowSuggestionsScreenState extends State<FollowSuggestionsScreen> {
  late List<DummySuggestedUser> users;

  @override
  void initState() {
    super.initState();
    users = dummySuggestedUsers;
  }

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SectionTitle(
                title: 'Discover People',
                subTitle: 'Follow people to see their posts, reels adn stories',
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 4.h,
                    ),
                    leading: CustomCircleAvatar(
                      radius: 24.r,
                      imgUrl: user.imageUrl,
                    ),
                    title: Text(
                      user.username,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: GoogleFonts.outfit(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          'Suggested for you',
                          style: GoogleFonts.outfit(
                            color: Colors.grey,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    trailing: IgFollowButton(
                      isFollowing: user.isFollowing,
                      onTap: () {
                        setState(() {
                          user.isFollowing = !user.isFollowing;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.3)),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: IGButton(
                  text: 'Next',
                  onPressed: () {
                    // Navigate to main screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MainScreen();
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
