import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
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

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              //
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

                        return PostVideoPlayer(
                          videoUrl: media['url'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
