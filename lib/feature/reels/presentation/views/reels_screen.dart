import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/utils/app_bottom_sheet.dart';
import 'package:flutter_instagram_clone/core/utils/reel_dummy_data.dart';
import 'package:flutter_instagram_clone/feature/comments/presentation/views/comments_screen.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/post_video_player.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/share_post_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ReelsScreen extends StatefulWidget {
  final int initialIndex;

  const ReelsScreen({super.key, this.initialIndex = 0});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late final PageController _controller;

  // locally toggled follow state, keyed by reel username (per P1-3 follow pill)
  final Set<String> _following = {};
  final Set<String> _likedReels = {};

  void _toggleFollow(String username) {
    setState(() {
      if (!_following.remove(username)) {
        _following.add(username);
      }
    });
  }

  void _toggleLike(String username) {
    setState(() {
      if (!_likedReels.remove(username)) {
        _likedReels.add(username);
      }
    });
  }

  void _openComments() {
    showAppBottomSheet(
      context: context,
      child: CommentsScreen(post: {'commentsData': []}),
    );
  }

  void _shareReel(Map<String, dynamic> reel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SharePostBottomSheet(post: reel),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reels = ReelDummyData.reels;
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          final reel = reels[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              PostVideoPlayer(videoUrl: reel['videoUrl']),
              Positioned(
                right: 8.w,
                bottom: 80.h,
                child: Column(
                  children: [
                    _Action(
                      icon: _likedReels.contains(reel['id'])
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: '${reel['likes']}',
                      iconColor: _likedReels.contains(reel['id'])
                          ? Colors.red
                          : Colors.white,
                      onTap: () => _toggleLike(reel['id']),
                    ),
                    SizedBox(height: 16.h),
                    _Action(
                      icon: Icons.comment_outlined,
                      label: '${reel['comments']}',
                      onTap: () => _openComments(),
                    ),
                    SizedBox(height: 16.h),
                    _Action(
                      icon: Icons.send_outlined,
                      label: 'Share',
                      onTap: () => _shareReel(reel),
                    ),
                    SizedBox(height: 16.h),
                    const _Action(icon: Icons.more_vert, label: ''),
                  ],
                ),
              ),
              Positioned(
                left: 12.w,
                right: 70.w,
                bottom: 20.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomCircleAvatar(
                          imgUrl: reel['profilePic'],
                          radius: 14.r,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          reel['username'],
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () => _toggleFollow(reel['username']),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              _following.contains(reel['username']) ||
                                      reel['isFollowing'] == true
                                  ? 'Following'
                                  : 'Follow',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      reel['caption'],
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            reel['audioTitle'],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;
  const _Action({
    required this.icon,
    required this.label,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: iconColor ?? Colors.white, size: 28.sp),
          if (label.isNotEmpty)
            Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
        ],
      ),
    );
  }
}
