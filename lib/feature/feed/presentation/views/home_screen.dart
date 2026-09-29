import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/utils/post_dummy_data.dart';
import 'package:flutter_instagram_clone/core/utils/stories_dummy_data.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/suggested_users_section.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/threads_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/post_card.dart';
import '../widgets/story_circle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final Random _random = Random();

  // scroll controller to preserve position
  late final ScrollController _scrollController;

  // random indices for special section (start from 1 to avoid first item)
  late final int suggestedIndex =
      1 + _random.nextInt(PostDummyData.posts.length - 1);

  late final int threadsIndex = _generateThreadsIndex();

  int _generateThreadsIndex() {
    int index;
    do {
      index = 1 + _random.nextInt(PostDummyData.posts.length);
    } while (index == suggestedIndex);
    return index;
  }

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
              // insert suggested users section randomly
              if (index == suggestedIndex) {
                return SuggestedUsersSection();
              }
              // insert threads section randomly
              if (index == threadsIndex) {
                return ThreadsSection();
              }
              // adjust post index for inserted sections
              int numInsertedBefore = 0;
              if (index > suggestedIndex) numInsertedBefore++;
              if (index > threadsIndex) numInsertedBefore++;

              final postIndex = index - numInsertedBefore;
              return PostCard(
                snap: PostDummyData.posts[postIndex],
                isMyPost: false,
              );
            }, childCount: PostDummyData.posts.length),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; // keeps start alive
}
