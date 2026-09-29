import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/state/follow_store.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_instagram_clone/feature/message/presentation/views/chat_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileContent(user: DummyData.currentUser, isMe: true);
  }
}

class ProfileContent extends ConsumerStatefulWidget {
  final Map<String, dynamic> user;
  final bool isMe;
  const ProfileContent({super.key, required this.user, this.isMe = false});

  @override
  ConsumerState<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends ConsumerState<ProfileContent> {
  int _tabIndex = 0; // 0 posts, 1 reels, 2 tagged

  void _onPrimaryAction() {
    if (widget.isMe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Edit profile — coming in a later phase')),
      );
      return;
    }
    ref
        .read(followProvider.notifier)
        .toggle(widget.user['username'] as String);
  }

  void _onSecondaryAction() {
    if (widget.isMe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Share profile — coming in a later phase')),
      );
      return;
    }
    // Message → open a chat with this user
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          chat: {
            'username': widget.user['username'],
            'profilePic': widget.user['profilePic'],
            'messages': <Map<String, dynamic>>[],
          },
        ),
      ),
    );
  }

  int get _gridCount {
    if (_tabIndex == 1) return DummyData.exploreMedia.length;
    return DummyData.savedPosts.length;
  }

  Widget _gridItem(int i) {
    if (_tabIndex == 1) {
      // reels tab: static video/image tiles until real reel media exists
      final item = DummyData.exploreMedia[i % DummyData.exploreMedia.length];
      final isVideo = item['type'] == 'video';
      return Stack(
        fit: StackFit.expand,
        children: [
          if (isVideo)
            Container(
              color: Colors.grey.shade900,
              child: const Icon(Icons.play_arrow, color: Colors.white),
            )
          else
            CachedNetworkImage(
              imageUrl: item['url'],
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(color: Colors.black),
              ),
            ),
        ],
      );
    }
    // posts / tagged tabs share the savedPosts grid (static for now)
    return CachedNetworkImage(
      imageUrl: DummyData.savedPosts[i]['image'],
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final posts = DummyData.savedPosts;
    final isFollowing = ref.watch(
      followProvider.select((f) => f[user['username']] ?? false),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          user['username'],
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomCircleAvatar(
                        imgUrl: user['profilePic'],
                        radius: 36.r,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _Stat(
                              label: 'Posts',
                              value: '${posts.length}',
                            ),
                            _Stat(
                              label: 'Followers',
                              value: '${user['followers'] ?? 0}',
                            ),
                            _Stat(
                              label: 'Following',
                              value: '${user['following'] ?? 0}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    user['name'] ?? '',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    user['bio'] ?? '',
                    style: GoogleFonts.outfit(color: Colors.white),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _Btn(
                          text: widget.isMe
                              ? 'Edit profile'
                              : (isFollowing ? 'Following' : 'Follow'),
                          filled: !widget.isMe && !isFollowing,
                          onTap: _onPrimaryAction,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _Btn(
                          text: widget.isMe ? 'Share profile' : 'Message',
                          filled: false,
                          onTap: _onSecondaryAction,
                        ),
                      ),
                    ],
                  ),
                  // highlights row (collections double as highlights)
                  SizedBox(height: 14.h),
                  SizedBox(
                    height: 80.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: DummyData.collections.length,
                      separatorBuilder: (_, __) => SizedBox(width: 14.w),
                      itemBuilder: (context, i) {
                        final c = DummyData.collections[i];
                        return _Highlight(name: c['name'] as String);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // posts / reels / tagged tabs
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TabIcon(
                  icon: Icons.grid_view_rounded,
                  selected: _tabIndex == 0,
                  onTap: () => setState(() => _tabIndex = 0),
                ),
                _TabIcon(
                  icon: Icons.play_circle_outline,
                  selected: _tabIndex == 1,
                  onTap: () => setState(() => _tabIndex = 1),
                ),
                _TabIcon(
                  icon: Icons.person_outline,
                  selected: _tabIndex == 2,
                  onTap: () => setState(() => _tabIndex = 2),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(color: Colors.grey.shade800, height: 1),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) => _gridItem(i),
              childCount: _gridCount,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13.sp),
        ),
      ],
    );
  }
}

class _Highlight extends StatelessWidget {
  final String name;

  const _Highlight({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCircleAvatar(
          imgUrl: DummyData.getCollectionPreview(name),
          radius: 26.r,
        ),
        SizedBox(height: 4.h),
        Text(
          name,
          style: GoogleFonts.outfit(color: Colors.grey, fontSize: 11.sp),
        ),
      ],
    );
  }
}

class _TabIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: selected ? Colors.white : Colors.grey,
        size: 26.sp,
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String text;
  final bool filled;
  final VoidCallback onTap;
  const _Btn({
    required this.text,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? Colors.blue : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}