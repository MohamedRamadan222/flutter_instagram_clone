import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/post_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final bool isMyPost;

  const PostCard({super.key, required this.snap, required this.isMyPost});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  bool _showHeart = false;
  int _likesCount = 0;
  int _commentsCount = 0;
  int _repostsCount = 0;
  int _sharesCount = 0;
  late bool _isFollowingPostUser;

  bool _isBookMarked = false;
  bool _isReposted = false;

  bool _isExpanded = false;
  static const int _maxLine = 1;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.snap['likes'];
    _commentsCount = widget.snap['comments'] ?? 0;
    _repostsCount = widget.snap['reposts'] ?? 0;
    _sharesCount = widget.snap['shares'] ?? 0;
    _isFollowingPostUser = widget.snap['isFollowing'] ?? false;
  }

  void _handeDoubleTap() {
    if (!_isLiked) {
      _handleLike();
    }
    setState(() {
      _showHeart = true;
    });

    Future.delayed(Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _showHeart = false;
        });
      }
    });
  }

  void _handleLike() {
    setState(() {
      if (!_isLiked) {
        _likesCount++;
      } else {
        _likesCount--;
      }
      _isLiked = !_isLiked;
    });
  }

  void _handelRepost() {
    setState(() {
      _isReposted = !_isReposted;
      _isReposted ? _repostsCount++ : _repostsCount--;
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
                            onPressed: () {
                              setState(() {
                                _isFollowingPostUser = !_isFollowingPostUser;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              backgroundColor: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _isFollowingPostUser ? 'Following' : 'Follow',
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
              setState(() {
                _showHeart = !_showHeart;
              });
            },
            child: SizedBox(
              height: 320,
              child: Stack(
                children: [
                  GestureDetector(
                    onDoubleTap: _handeDoubleTap,
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
                          return CachedNetworkImage(
                            imageUrl: media['url'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade900,
                              highlightColor: Colors.grey.shade900,
                              child: Container(color: Colors.black),
                            ),
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
                  if (_isReposted)
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
                    onPressed: _handleLike,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.white,
                      size: 28,
                    ),
                  ),

                  if (_likesCount > 0)
                    Text(
                      '$_likesCount',
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
                    },
                    icon: Image.asset(
                      'assets/icons/comment.png',
                      color: Colors.white,
                      width: 22,
                    ),
                  ),

                  if (_commentsCount > 0)
                    Text(
                      '$_commentsCount',
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
                    onPressed: _handelRepost,
                    icon: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.loop, color: Colors.white, size: 26),
                        if (_isReposted)
                          const Positioned(
                            right: 0,
                            bottom: 2,
                            child: Icon(Icons.check_circle, size: 14),
                          ),
                      ],
                    ),
                  ),
                  if (_repostsCount > 0)
                    Text(
                      '$_repostsCount',
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
                    },
                    icon: Image.asset(
                      'assets/icons/message_icon.png',
                      color: Colors.white,
                      width: 22,
                    ),
                  ),

                  if (_sharesCount > 0)
                    Text(
                      '$_sharesCount',
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
                  // save to collection bottomSheet
                },
                icon: Icon(
                  _isBookMarked
                      ? Icons.bookmark_outline
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
                  '$_likesCount likes',
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
                                _isExpanded ? 'less' : 'true',
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

                if (widget.snap['comments'] > 0)
                  GestureDetector(
                    onTap: () {
                      // show comment bottomSheet
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'View all ${widget.snap['comments']} comments',
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
