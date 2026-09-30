import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_instagram_clone/core/data/backend_data_source.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_instagram_clone/core/utils/post_dummy_data.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Comments per post, keyed by post id (P2-2).
///
/// Seeded from each post's dummy `commentsData`; new comments added from the
/// comments sheet land here so they survive the sheet being closed/reopened.
class CommentsStore
    extends Notifier<Map<String, List<Map<String, dynamic>>>> {
  @override
  Map<String, List<Map<String, dynamic>>> build() {
    return {
      for (final post in PostDummyData.posts)
        post['id'] as String: [
          for (final c in post['commentsData'] as List? ?? [])
            Map<String, dynamic>.from(c as Map),
        ],
    };
  }

  List<Map<String, dynamic>> of(String postId) => state[postId] ?? const [];

  int countOf(String postId) => of(postId).length;

  /// Phase 5: replaces a post's comments with backend rows when configured,
  /// merging optimistic local comments instead of discarding them.
  Future<bool> hydrate(String postId) async {
    final comments =
        await ref.read(backendDataSourceProvider).fetchComments(postId);
    if (comments == null) return false;
    final local = state[postId] ?? const <Map<String, dynamic>>[];
    final seen = {
      for (final c in comments) '${c['username']}|${c['comment']}',
    };
    final merged = [
      ...comments,
      for (final c in local)
        if (!seen.contains('${c['username']}|${c['comment']}')) c,
    ];
    state = {...state, postId: merged};
    return true;
  }

  void add(String postId, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final comment = <String, dynamic>{
      'username': DummyData.currentUser['username'],
      'profilePic': DummyData.currentUser['profilePic'],
      'comment': trimmed,
      'likes': 0,
      'time': timeago.format(DateTime.now()),
    };
    state = {
      ...state,
      postId: [...of(postId), comment],
    };
    // Phase 5: persist when a backend is configured (best-effort).
    ref.read(backendDataSourceProvider).addComment(
          postId: postId,
          username: DummyData.currentUser['username'] as String,
          text: trimmed,
        );
  }
}

final commentsProvider =
    NotifierProvider<CommentsStore, Map<String, List<Map<String, dynamic>>>>(
  CommentsStore.new,
);