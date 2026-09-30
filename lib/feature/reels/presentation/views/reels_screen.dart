import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/common/widgets/feed_states.dart';
import 'package:flutter_instagram_clone/core/config/app_config.dart';
import 'package:flutter_instagram_clone/core/state/follow_store.dart';
import 'package:flutter_instagram_clone/core/state/reels_likes_store.dart';
import 'package:flutter_instagram_clone/core/state/reels_store.dart';
import 'package:flutter_instagram_clone/feature/create/presentation/views/create_reel_screen.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/post_video_player.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/share_post_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const ReelsScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  late final PageController _controller;
  bool _loading = false;
  bool _loadError = false;

  @override
  void initState() {
    super.initState();
    final reels = ref.read(reelsProvider);
    final safeIndex = reels.isEmpty
        ? 0
        : widget.initialIndex.clamp(0, reels.length - 1);
    _controller = PageController(initialPage: safeIndex);
    if (AppConfig.hasBackend) _hydrate();
  }

  Future<void> _hydrate() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _loadError = false;
    });
    var failed = false;
    try {
      final ok = await ref.read(reelsProvider.notifier).hydrate();
      if (!ok && ref.read(reelsProvider).isEmpty) failed = true;
    } catch (_) {
      failed = true;
    }
    if (!mounted) return;
    setState(() {
      _loading = false;
      _loadError = failed;
    });
  }

  @override
  void didUpdateWidget(ReelsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      final reels = ref.read(reelsProvider);
      if (reels.isEmpty) return;
      final safe = widget.initialIndex.clamp(0, reels.length - 1);
      _controller.jumpToPage(safe);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reels = ref.watch(reelsProvider);
    if (_loading && reels.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_loadError && reels.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black, elevation: 0),
        body: ErrorState(
          message: 'Couldn\'t load reels. Check your connection.',
          onRetry: _hydrate,
        ),
      );
    }
    if (reels.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black, elevation: 0),
        body: EmptyState(
          icon: Icons.movie_outlined,
          title: 'No reels yet',
          subtitle: 'Create the first reel to get started.',
          actionLabel: 'Create reel',
          onAction: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateReelScreen()),
            );
          },
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          // P3-4/P3-5: create a new reel from the reels tab
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateReelScreen()),
              );
            },
            icon: const Icon(Icons.camera_alt_outlined),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: reels.length,
        itemBuilder: (context, index) => _ReelPage(reel: reels[index]),
      ),
    );
  }
}

class _ReelPage extends ConsumerWidget {
  final Map<String, dynamic> reel;

  const _ReelPage({required this.reel});

  void _openComments(BuildContext context) {
    context.push('/comments/${reel['id'] ?? ''}');
  }

  void _shareReel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SharePostBottomSheet(post: reel),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reelId = '${reel['id'] ?? ''}';
    final reelUsername = '${reel['username'] ?? ''}';
    final isLiked = ref.watch(
      reelsLikesProvider.select((s) => s.contains(reelId)),
    );
    final isFollowing = ref.watch(
      followProvider.select((f) => f[reelUsername] ?? false),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        PostVideoPlayer(
          videoUrl: '${reel['videoUrl'] ?? ''}',
          playerId: reelId,
        ),
        Positioned(
          right: 8.w,
          bottom: 80.h,
          child: Column(
            children: [
              _Action(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                label: '${reel['likes'] ?? ''}',
                iconColor: isLiked ? Colors.red : Colors.white,
                onTap: () =>
                    ref.read(reelsLikesProvider.notifier).toggle(reelId),
              ),
              SizedBox(height: 16.h),
              _Action(
                icon: Icons.comment_outlined,
                label: '${reel['comments'] ?? ''}',
                onTap: () => _openComments(context),
              ),
              SizedBox(height: 16.h),
              _Action(
                icon: Icons.send_outlined,
                label: 'Share',
                onTap: () => _shareReel(context),
              ),
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
                    imgUrl: '${reel['profilePic'] ?? ''}',
                    radius: 14.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      reelUsername,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => ref
                        .read(followProvider.notifier)
                        .toggle(reelUsername),
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
                        isFollowing ? 'Following' : 'Follow',
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
                '${reel['caption'] ?? ''}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                      '${reel['audioTitle'] ?? ''}',
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