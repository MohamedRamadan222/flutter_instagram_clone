import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/common/widgets/custom_circle_avatar.dart';
import 'package:flutter_instagram_clone/core/theme/app_colors.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_instagram_clone/feature/profile/presentation/views/user_profile_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final media = DummyData.exploreMedia;
    final accounts = DummyData.accounts
        .where(
          (a) =>
              _query.isEmpty ||
              (a['username'] as String).toLowerCase().contains(
                _query.toLowerCase(),
              ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: TextField(
            onChanged: (v) => setState(() => _query = v),
            style: GoogleFonts.outfit(color: Colors.white),
            decoration: InputDecoration(
              icon: const Icon(Icons.search, color: Colors.grey),
              hintText: 'Search',
              hintStyle: GoogleFonts.outfit(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          if (_query.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => ListTile(
                  leading: CustomCircleAvatar(
                    imgUrl: accounts[i]['profilePic'],
                    radius: 20.r,
                  ),
                  title: Text(
                    accounts[i]['username'],
                    style: GoogleFonts.outfit(color: Colors.white),
                  ),
                  subtitle: Text(
                    accounts[i]['name'],
                    style: GoogleFonts.outfit(color: Colors.grey),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserProfileScreen(user: accounts[i]),
                    ),
                  ),
                ),
                childCount: accounts.length,
              ),
            )
          else
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final item = media[i % media.length];
                  final isVideo = item['type'] == 'video';
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: isVideo
                            ? 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?q=80&w=400&auto=format&fit=crop'
                            : item['url'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: AppColors.shimmerBase,
                          highlightColor: AppColors.shimmerHighlight,
                          child: Container(color: Colors.black),
                        ),
                      ),
                      if (isVideo)
                        const Positioned(
                          top: 6,
                          right: 6,
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                    ],
                  );
                },
                childCount: 30,
              ),
            ),
        ],
      ),
    );
  }
}
