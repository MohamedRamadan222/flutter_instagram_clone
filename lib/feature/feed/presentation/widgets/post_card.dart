import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/state/comments_store.dart';
import 'package:flutter_instagram_clone/core/state/follow_store.dart';
import 'package:flutter_instagram_clone/core/state/post_reactions_store.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_instagram_clone/feature/comments/presentation/views/comments_screen.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/post_options_bottom_sheet.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/post_video_player.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/save_to_collection_bottom_sheet.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/share_post_bottom_sheet.dart';
import 'package:flutter_instagram_clone/feature/reels/presentation/views/reels_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/reel_dummy_data.dart';
import '../../../profile/presentation/views/user_profile_screen.dart';

class PostCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> snap;
  final bool isMyPost;

  const PostCard({super.key, required this.snap, required this.isMyPost});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _showHeart = false;
  bool _isExpanded = false;
  static const int _maxLine = 1;

  String get _postId => widget.snap['id'] as String;

  @override
  void initState() {
    super.initState();
  }

  void _handleDoubleTap() {
    final reactions = ref.read(postReactionsProvider)[_postId]!;
    if (!reactions.liked) {
      ref.read(postReactionsProvider.notifier).toggleLike(_postId);
    }
    setState(() {
      _showHeart = true;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _showHeart = false;
        });
      }
    });
  }

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = DummyData.currentUser;
    final caption = widget.snap['caption'] ?? '';
    final reactions =
        ref.watch(postReactionsProvider.select((m) => m[_postId]))!;
    final commentsCount =
        ref.watch(commentsProvider.select((m) => m[_postId]?.length ?? 0));
    final isFollowingUser = ref.watch(
      followProvider.select((f) => f[widget.snap['username']] ?? false),
    );
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 0).copyWith(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: GestureDetector(
              onTap: () {
                // Nav to profile screen
                final user = {
                  'username': widget.snap['username'],
                  'profilePic': widget.snap['profilePic'],
                  'name': widget.snap['name'],
                  'bio': widget.snap['bio'] ?? 'Goal Setting',
                  'followers': 40303,
                  'following': 3020,
                  'posts': 9,
                };
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UserProfileScreen(user: user);
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  CustomCircleAvatar(
                    imgUrl: widget.snap['profilePic'],
                    radius: 16,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.snap['username'],
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (widget.snap['isSponsored'] == true)
                                Text(
                                  ' • Sponsored',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                          if (widget.snap['location'] != null &&
                              widget.snap['location'].toString().isNotEmpty)
                            Text(
                              widget.snap['location'],
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (widget.isMyPost)
                        SizedBox(
                          height: 30.h,
                          child: ElevatedButton(
                            onPressed: () => ref
                                .read(followProvider.notifier)
                                .toggle(widget.snap['username']),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              backgroundColor: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isFollowingUser ? 'Following' : 'Follow',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 6),
                      IconButton(
                        onPressed: () {
                          // show post options bottomsSheet
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Color(0xff00080E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) => PostOptionsBottomSheet(),
                          );
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // image section
          GestureDetector(
            onTap: () {
              final media = widget.snap['media'] as List;
              // check if post contains only 1 video
              if (media.length == 1 && media[0]['type'] == 'video') {
                final videoUrl = media[0]['reelId'];

                // find reel index with same video
                final index = ReelDummyData.reels.indexWhere(
                  (reel) => reel['id'] == videoUrl,
                );

                if (index != -1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReelsScreen(initialIndex: index),
                    ),
                  );
                }
              }
            },
            child: SizedBox(
              height: 320,
              child: Stack(
                children: [
                  GestureDetector(
                    onDoubleTap: _handleDoubleTap,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: (widget.snap['media'] as List).length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final media = widget.snap['media'][index];
                        if (media['type'] == 'image') {
                          final url = media['url'] as String;
                          if (url.startsWith('http')) {
                            return CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade900,
                                highlightColor: Colors.grey.shade900,
                                child: Container(color: Colors.black),
                              ),
                            );
                          }
                          // Phase 3: locally picked post media
                          return Image.file(
                            File(url),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        }

                        return PostVideoPlayer(videoUrl: media['url']);
                      },
                    ),
                  ),
                  // Page Indicator
                  if (widget.snap['media'].length > 1)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${_currentIndex + 1} /${widget.snap['media'].length}",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  // heart animation
                  AnimatedOpacity(
                    opacity: _showHeart ? 1 : 0,
                    duration: Duration(milliseconds: 300),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 120,
                      ),
                    ),
                  ),

                  // dot indicator
                  if (widget.snap['media'].length > 1)
                    Positioned(
                      bottom: 10,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.snap['media'].length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 3),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // repost avatar overlay
                  if (reactions.reposted)
                    Positioned(
                      bottom: 8,
                      left: 12,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // user avatar
                          Container(
                            width: 40,
                            height: 40,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: CustomCircleAvatar(
                              radius: 20,
                              imgUrl: user['profilePic'],
                            ),
                          ),

                          // repost Icon
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade400,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.loop,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Actions button
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => ref
                        .read(postReactionsProvider.notifier)
                        .toggleLike(_postId),
                    icon: Icon(
                      reactions.liked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: reactions.liked ? Colors.red : Colors.white,
                      size: 28,
                    ),
                  ),

                  if (reactions.likes > 0)
                    Text(
                      '${reactions.likes}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // show comment bottomSheet
                      showAppBottomSheet(
                        context: context,
                        child: CommentsScreen(post: widget.snap),
                      );
                    },
                    icon: Image.asset(
                      'assets/icons/comment.png',
                      color: Colors.white,
                      width: 22,
                    ),
                  ),

                  if (commentsCount > 0)
                    Text(
                      '$commentsCount',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => ref
                        .read(postReactionsProvider.notifier)
                        .toggleRepost(_postId),
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.loop, color: Colors.white, size: 26),
                        if (reactions.reposted)
                          const Positioned(
                            right: 0,
                            bottom: 2,
                            child: Icon(Icons.check_circle, size: 14),
                          ),
                      ],
                    ),
                  ),
                  if (reactions.reposts > 0)
                    Text(
                      '${reactions.reposts}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // show share post bottomSheet
                      ref
                          .read(postReactionsProvider.notifier)
                          .addShare(_postId);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) =>
                            SharePostBottomSheet(post: widget.snap),
                      );
                    },
                    icon: Image.asset(
                      'assets/icons/message_icon.png',
                      color: Colors.white,
                      width: 22,
                    ),
                  ),

                  if (reactions.shares > 0)
                    Text(
                      '${reactions.shares}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  // toggle save + pick a collection
                  ref
                      .read(postReactionsProvider.notifier)
                      .toggleSave(_postId);
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => SaveToCollectionBottomSheet(
                      post: widget.snap,
                      parentContext: context,
                    ),
                  );
                },
                icon: Icon(
                  reactions.saved
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),

          // description section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reactions.likes} likes',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),

                // caption with more/less
                LayoutBuilder(
                  builder: (context, constraints) {
                    final span = TextSpan(
                      text: '${widget.snap['username']}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: caption,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                    final tp = TextPainter(
                      text: span,
                      maxLines: _maxLine,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: constraints.maxWidth);

                    final isOverFlowing = tp.didExceedMaxLines;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: span,
                          maxLines: _isExpanded ? null : _maxLine,
                          overflow: TextOverflow.fade,
                        ),
                        if (isOverFlowing)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(
                                _isExpanded ? 'less' : 'more',
                                style: GoogleFonts.outfit(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                if (commentsCount > 0)
                  GestureDetector(
                    onTap: () {
                      // show comments bottomSheet
                      showAppBottomSheet(
                        context: context,
                        child: CommentsScreen(post: widget.snap),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'View all $commentsCount comments',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                Text(
                  widget.snap['timeAgo'],
                  style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
