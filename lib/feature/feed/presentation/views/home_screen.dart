import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/core/state/feed_posts_store.dart';
import 'package:flutter_instagram_clone/core/state/stories_store.dart';
import 'package:flutter_instagram_clone/core/utils/post_dummy_data.dart';
import 'package:flutter_instagram_clone/core/utils/threads_dummy_data.dart';
import 'package:flutter_instagram_clone/feature/create/presentation/views/create_post_screen.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/suggested_users_section.dart';
import 'package:flutter_instagram_clone/feature/feed/presentation/widgets/threads_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'activity_screen.dart';
import '../widgets/post_card.dart';
import '../widgets/story_circle.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final Random _random = Random();
  final ImagePicker _picker = ImagePicker();

  // stories marked as seen during this session (P1-7)
  final Set<String> _seenStories = {};

  // scroll controller to preserve position
  late final ScrollController _scrollController;

  // random indices for special sections (start from 1 to avoid first post),
  // computed against the seeded feed; posts only grow afterwards (P3-2).
  int get _totalItems => PostDummyData.posts.length + 2;

  late final int suggestedIndex =
      1 + _random.nextInt(_totalItems - 1);

  late final int threadsIndex = _generateThreadsIndex();

  int _generateThreadsIndex() {
    int index;
    do {
      index = 1 + _random.nextInt(_totalItems - 1);
    } while (index == suggestedIndex);
    return index;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  /// P3-3: pick a photo from the gallery and publish it as a story.
  Future<void> _publishStory() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null || !mounted) return;
    ref.read(storiesProvider.notifier).publishStory(picked.path);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final posts = ref.watch(feedPostsProvider);
    final stories = ref.watch(storiesProvider);
    final totalItems = posts.length + 2;
    return Scaffold(
      appBar: AppBar(
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
          // P3-5: create a new post from the feed
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              );
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ActivityScreen()),
              );
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
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return StoryCircle(
                    story: story,
                    forceSeen: _seenStories.contains(story['username']),
                    onViewed: () {
                      if (!mounted) return;
                      setState(() {
                        _seenStories.add(story['username']);
                      });
                    },
                    onAddStory: story['userName'] == 'Your story'
                        ? _publishStory
                        : null,
                  );
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
                return ThreadsSection(
                  threads: ThreadsDummyData.threads,
                );
              }
              // adjust post index for inserted sections
              int numInsertedBefore = 0;
              if (index > suggestedIndex) numInsertedBefore++;
              if (index > threadsIndex) numInsertedBefore++;

              final postIndex = index - numInsertedBefore;
              if (postIndex < 0 || postIndex >= posts.length) {
                return const SizedBox.shrink();
              }
              return PostCard(
                snap: posts[postIndex],
                isMyPost: false,
              );
            }, childCount: totalItems),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true; // keeps start alive
}