import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/utils/post_dummy_data.dart';
import 'package:flutter_instagram_clone/core/utils/stories_dummy_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/post_card.dart';
import '../widgets/story_circle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // scroll controller to preserve position
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator to create new post screen
          },
          icon: Icon(Icons.add),
        ),
        title: Text(
          'Instagram',
          style: GoogleFonts.grandHotel(
            fontWeight: FontWeight.w600,
            fontSize: 28.sp,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to activity screen
            },
            icon: Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: StoriesDummyData.stories.length,
                itemBuilder: (context, index) {
                  return StoryCircle(story: StoriesDummyData.stories[index]);
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(color: Colors.grey, height: 1, thickness: 0.2),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return PostCard(snap: PostDummyData.posts[index], isMyPost: true);
            }, childCount: PostDummyData.posts.length),
          ),
        ],
      ),
    );
  }
}
