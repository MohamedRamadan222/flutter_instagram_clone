import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_instagram_clone/core/utils/post_dummy_data.dart';

/// Session state of one post's interactive counters.
class PostReactions {
  final bool liked;
  final int likes;
  final bool saved;
  final bool reposted;
  final int reposts;
  final int shares;

  const PostReactions({
    required this.liked,
    required this.likes,
    required this.saved,
    required this.reposted,
    required this.reposts,
    required this.shares,
  });

  PostReactions copyWith({
    bool? liked,
    int? likes,
    bool? saved,
    bool? reposted,
    int? reposts,
    int? shares,
  }) {
    return PostReactions(
      liked: liked ?? this.liked,
      likes: likes ?? this.likes,
      saved: saved ?? this.saved,
      reposted: reposted ?? this.reposted,
      reposts: reposts ?? this.reposts,
      shares: shares ?? this.shares,
    );
  }
}

/// Like/save/repost/share counters per post, keyed by post id.
///
/// Replaces the scattered `setState` counters in `post_card.dart` (P2-2, P2-3)
/// so the feed card and the comments sheet agree on counts.
class PostReactionsStore
    extends Notifier<Map<String, PostReactions>> {
  @override
  Map<String, PostReactions> build() {
    return {
      for (final post in PostDummyData.posts)
        post['id'] as String: PostReactions(
          liked: false,
          likes: post['likes'] as int,
          saved: false,
          reposted: false,
          reposts: post['reposts'] as int? ?? 0,
          shares: post['shares'] as int? ?? 0,
        ),
    };
  }

  PostReactions of(String postId) => state[postId]!;

  void toggleLike(String postId) {
    final r = of(postId);
    state = {
      ...state,
      postId: r.copyWith(
        liked: !r.liked,
        likes: r.likes + (r.liked ? -1 : 1),
      ),
    };
  }

  void toggleSave(String postId) {
    final r = of(postId);
    state = {...state, postId: r.copyWith(saved: !r.saved)};
  }

  /// Sets the saved flag outright, so the save sheet can write its selection
  /// back to the same store the feed bookmark reads (P2-2).
  void setSaved(String postId, bool saved) {
    final r = of(postId);
    state = {...state, postId: r.copyWith(saved: saved)};
  }

  /// Registers a freshly created post (Phase 3) so the feed card has
  /// reaction state for it. No-op when the post is already known.
  void seedPost(Map<String, dynamic> post) {
    final id = post['id'] as String;
    if (state.containsKey(id)) return;
    state = {
      ...state,
      id: PostReactions(
        liked: false,
        likes: post['likes'] as int? ?? 0,
        saved: false,
        reposted: false,
        reposts: post['reposts'] as int? ?? 0,
        shares: post['shares'] as int? ?? 0,
      ),
    };
  }

  void toggleRepost(String postId) {
    final r = of(postId);
    state = {
      ...state,
      postId: r.copyWith(
        reposted: !r.reposted,
        reposts: r.reposts + (r.reposted ? -1 : 1),
      ),
    };
  }

  void addShare(String postId) {
    final r = of(postId);
    state = {...state, postId: r.copyWith(shares: r.shares + 1)};
  }
}

final postReactionsProvider =
    NotifierProvider<PostReactionsStore, Map<String, PostReactions>>(
  PostReactionsStore.new,
);