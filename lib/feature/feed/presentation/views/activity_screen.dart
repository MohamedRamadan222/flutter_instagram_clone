import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/common/widgets/ig_follow_button.dart';
import 'package:flutter_instagram_clone/core/state/follow_store.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/core/utils/notifications_dummy_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        children: [
          _Header(title: 'Today'),
          ...NotificationsDummyData.today.map(_Tile.new),
          _Header(title: 'This week'),
          ...NotificationsDummyData.week.map(_Tile.new),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15.sp,
        ),
      ),
    );
  }
}

class _Tile extends ConsumerWidget {
  final Map<String, dynamic> item;
  const _Tile(this.item);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = this.item;
    final username = item['username'] as String;
    final isFollowing = ref.watch(
      followProvider.select((follows) => follows[username] ?? false),
    );
    return ListTile(
      leading: CustomCircleAvatar(imgUrl: item['profilePic'], radius: 20.r),
      title: RichText(
        text: TextSpan(
          text: '${item['username']} ',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
          children: [
            TextSpan(
              text: '${item['text']} ',
              style: GoogleFonts.outfit(fontWeight: FontWeight.normal),
            ),
            TextSpan(
              text: '${item['timeAgo']}',
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
          ],
        ),
      ),
      trailing: item['previewImage'] != null
          ? CachedNetworkImage(
              imageUrl: item['previewImage'],
              width: 44.w,
              height: 44.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(color: Colors.black),
              ),
            )
          : IgFollowButton(
              isFollowing: isFollowing,
              onTap: () =>
                  ref.read(followProvider.notifier).toggle(username),
            ),
    );
  }
}
