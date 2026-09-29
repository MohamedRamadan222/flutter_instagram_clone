import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/core/utils/notifications_dummy_data.dart';
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

class _Tile extends StatefulWidget {
  final Map<String, dynamic> item;
  const _Tile(this.item);

  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> {
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
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
          : SizedBox(
              height: 30.h,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _isFollowing = !_isFollowing);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFollowing
                      ? Colors.grey.shade800
                      : Colors.blue,
                ),
                child: Text(
                  _isFollowing ? 'Following' : 'Follow',
                  style: GoogleFonts.outfit(color: Colors.white),
                ),
              ),
            ),
    );
  }
}
