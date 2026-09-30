import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/state/stories_store.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/core/utils/image_cache.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

/// Full-screen story viewer: one [PageView] page per story image across all
/// users, auto-advancing with a per-story progress bar. Tap left/right to
/// navigate, tap the close button to leave. Reached via the `/story` route
/// (P4-2); the strip data comes from [storiesProvider].
class StoryViewScreen extends ConsumerStatefulWidget {
  /// Username whose stories the viewer should open on (first story).
  final String? initialUser;

  const StoryViewScreen({super.key, this.initialUser});

  @override
  ConsumerState<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends ConsumerState<StoryViewScreen> {
  late final PageController _pageController;
  late final List<Map<String, dynamic>> _stories;
  late final List<_StoryPage> _pages;
  int _page = 0;
  Timer? _timer;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _stories = ref.read(storiesProvider);
    _pages = _flatten(_stories);
    final userIndex = _stories.indexWhere(
      (s) => s['username'] == widget.initialUser,
    );
    _page = _startPageForUser(userIndex < 0 ? 0 : userIndex);
    _pageController = PageController(initialPage: _page);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Flattens per-user story lists into a single list of story pages.
  static List<_StoryPage> _flatten(List<Map<String, dynamic>> users) {
    return [
      for (final user in users)
        for (var i = 0; i < (user['stories'] as List).length; i++)
          _StoryPage(
            user: user,
            imageUrl: (user['stories'] as List)[i]['imageUrl'],
            indexInUser: i,
            userStoryCount: (user['stories'] as List).length,
          ),
    ];
  }

  /// Flat page index of the first story of [userIndex].
  int _startPageForUser(int userIndex) {
    if (_pages.isEmpty) return 0;
    var page = 0;
    for (var u = 0; u < userIndex && u < _stories.length; u++) {
      page += (_stories[u]['stories'] as List).length;
    }
    return page.clamp(0, _pages.length - 1);
  }

  void _startTimer() {
    _timer?.cancel();
    _progress = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) return;
      setState(() => _progress += 0.01);
      if (_progress >= 1) _nextStory();
    });
  }

  void _goTo(int page) {
    if (page >= _pages.length) {
      // end of all stories: leave (once)
      _timer?.cancel();
      Navigator.pop(context);
      return;
    }
    if (page < 0) return; // already at the first story
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _nextStory() => _goTo(_page + 1);

  void _prevStory() => _goTo(_page - 1);

  void _onPageChanged(int page) {
    setState(() => _page = page);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) {
      return const Scaffold(backgroundColor: Colors.black);
    }
    final current = _pages[_page];
    final user = current.user;
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (d) {
          final x = d.globalPosition.dx;
          if (x < MediaQuery.of(context).size.width / 2) {
            _prevStory();
          } else {
            _nextStory();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              // P6-2: full-screen stories; neighbors init lazily.
              allowImplicitScrolling: false,
              itemCount: _pages.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final url = _pages[index].imageUrl;
                if (url.startsWith('http')) {
                  return CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    // P6-2: full-screen story; cap decode at 1080px.
                    memCacheWidth: ImageCacheSizes.feed,
                    memCacheHeight: ImageCacheSizes.feed,
                    maxWidthDiskCache: ImageCacheSizes.feed,
                    maxHeightDiskCache: ImageCacheSizes.feed,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppColors.shimmerBase,
                      highlightColor: AppColors.shimmerHighlight,
                      child: Container(color: Colors.black),
                    ),
                  );
                }
                // Phase 3: locally picked story media
                return Image.file(File(url), fit: BoxFit.cover);
              },
            ),
            // per-story progress bar of the current user
            Positioned(
              top: MediaQuery.of(context).padding.top + 8.h,
              left: 8.w,
              right: 8.w,
              child: Row(
                children: List.generate(
                  current.userStoryCount,
                  (i) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: i < current.indexInUser
                            ? 1
                            : i == current.indexInUser
                                ? _progress.clamp(0.0, 1.0)
                                : 0,
                        child: Container(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 20.h,
              left: 12.w,
              right: 12.w,
              child: Row(
                children: [
                  CustomCircleAvatar(
                    imgUrl: user['profileImage'],
                    radius: 14.r,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user['username'],
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryPage {
  final Map<String, dynamic> user;
  final String imageUrl;
  final int indexInUser;
  final int userStoryCount;

  const _StoryPage({
    required this.user,
    required this.imageUrl,
    required this.indexInUser,
    required this.userStoryCount,
  });
}