import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_suggested_user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SuggestedUsersSection extends StatefulWidget {
  const SuggestedUsersSection({super.key});

  @override
  State<SuggestedUsersSection> createState() => _SuggestedUsersSectionState();
}

class _SuggestedUsersSectionState extends State<SuggestedUsersSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Text(
                  'Suggested for you',
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  'See all',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 190.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: dummySuggestedUsers.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final user = dummySuggestedUsers[index];
                return _SuggestedCard(
                  user: user,
                  onFollow: () => setState(() {
                    user.isFollowing = !user.isFollowing;
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestedCard extends StatelessWidget {
  final DummySuggestedUser user;
  final VoidCallback onFollow;

  const _SuggestedCard({required this.user, required this.onFollow});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade800, width: 0.5),
      ),
      child: Column(
        children: [
          CustomCircleAvatar(imgUrl: user.imageUrl, radius: 32.r),
          SizedBox(height: 8.h),
          Text(
            user.username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            user.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 32.h,
            child: ElevatedButton(
              onPressed: onFollow,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    user.isFollowing ? Colors.grey.shade800 : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                user.isFollowing ? 'Following' : 'Follow',
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
