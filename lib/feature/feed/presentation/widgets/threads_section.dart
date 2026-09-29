import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ThreadsSection extends StatelessWidget {
  final List<Map<String, dynamic>> threads;

  const ThreadsSection({super.key, required this.threads});

  @override
  Widget build(BuildContext context) {
    if (threads.isEmpty) return const SizedBox.shrink();

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
                Icon(Icons.alternate_email, color: Colors.white, size: 20.sp),
                SizedBox(width: 6.w),
                Text(
                  'Threads for you',
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
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 210.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: threads.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final thread = threads[index];
                return _ThreadCard(thread: thread);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreadCard extends StatelessWidget {
  final Map<String, dynamic> thread;

  const _ThreadCard({required this.thread});

  @override
  Widget build(BuildContext context) {
    final String? image = thread['image'] as String?;
    final bool hasImage = image != null && image.isNotEmpty;

    return Container(
      width: 280.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade800, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomCircleAvatar(
                imgUrl: thread['profilePic'],
                radius: 16.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        thread['username'],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (thread['isVerified'] == true) ...[
                      SizedBox(width: 4.w),
                      Image.asset(
                        'assets/images/verified.png',
                        width: 14.w,
                        height: 14.w,
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                thread['timeAgo'],
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            thread['text'],
            maxLines: hasImage ? 2 : 4,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: Colors.white,
              height: 1.35,
            ),
          ),
          if (hasImage) ...[
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: image,
                height: 80.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.shimmerBase,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(color: Colors.black),
                ),
              ),
            ),
          ],
          const Spacer(),
          Row(
            children: [
              Icon(Icons.favorite_border, size: 18.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Text(
                '${thread['likes']}',
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 12.w),
              Image.asset(
                'assets/icons/comment.png',
                width: 16.w,
                color: Colors.grey,
              ),
              SizedBox(width: 4.w),
              Text(
                '${thread['replies']}',
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 12.w),
              Icon(Icons.loop, size: 18.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Text(
                '${thread['reposts']}',
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
