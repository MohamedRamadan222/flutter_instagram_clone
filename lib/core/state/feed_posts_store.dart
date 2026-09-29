import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_instagram_clone/core/state/post_reactions_store.dart';
import 'package:flutter_instagram_clone/core/utils/post_dummy_data.dart';

/// The feed's post list for this session (Phase 3).
///
/// Seeded from [PostDummyData.posts]; `addPost` inserts a created post at the
/// top so it is visible immediately without a restart (P3-2 acceptance).
class FeedPostsStore extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() => List.of(PostDummyData.posts);

  void addPost(Map<String, dynamic> post) {
    state = [post, ...state];
    // Give the new post reaction state so like/save/repost work on its card.
    ref.read(postReactionsProvider.notifier).seedPost(post);
  }
}

final feedPostsProvider =
    NotifierProvider<FeedPostsStore, List<Map<String, dynamic>>>(
  FeedPostsStore.new,
);