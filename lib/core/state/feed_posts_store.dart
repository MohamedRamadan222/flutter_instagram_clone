import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_instagram_clone/core/config/app_config.dart';
import 'package:flutter_instagram_clone/core/data/backend_data_source.dart';
import 'package:flutter_instagram_clone/core/state/post_reactions_store.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_instagram_clone/core/utils/post_dummy_data.dart';

/// The feed's post list for this session (Phase 3).
///
/// Seeded from [PostDummyData.posts]; with a backend configured (Phase 5) it
/// hydrates from Supabase with pagination (`refresh`/`loadMore`) and offline
/// cache fallback. [PostDummyData.posts] remains the offline/demo seed.
class FeedPostsStore extends Notifier<List<Map<String, dynamic>>> {
  int _page = 1;
  bool _hasMore = true;
  bool _busy = false;

  String get _me => DummyData.currentUser['username'] as String;

  @override
  List<Map<String, dynamic>> build() => [
        for (final p in PostDummyData.posts) Map<String, dynamic>.of(p),
      ];

  /// Reloads page 1 from the backend. Returns false when there is no backend
  /// or the fetch failed (state keeps the current/cached posts).
  Future<bool> refresh() async {
    if (_busy) return false;
    _busy = true;
    try {
      final posts = await ref
          .read(backendDataSourceProvider)
          .fetchPosts(page: 1, me: _me);
      if (posts == null) return false;
      if (posts.isEmpty) {
        // Empty backend: keep current feed instead of wiping to blank.
        _page = 1;
        _hasMore = false;
        return true;
      }
      state = posts;
      _page = 1;
      _hasMore = posts.length >= BackendDataSource.pageSize;
      ref.read(postReactionsProvider.notifier).seedBatch(posts);
      return true;
    } finally {
      _busy = false;
    }
  }

  /// Appends the next backend page when the user scrolls to the end (P5-3).
  Future<bool> loadMore() async {
    if (_busy || !_hasMore) return false;
    if (!AppConfig.hasBackend) return false; // dummy feed has no pages
    _busy = true;
    try {
      final next = await ref
          .read(backendDataSourceProvider)
          .fetchPosts(page: _page + 1, me: _me);
      if (next == null) return false; // transient error: retry next scroll
      if (next.isEmpty) {
        _hasMore = false;
        return false;
      }
      final existingIds = {for (final p in state) p['id']};
      final fresh = [
        for (final p in next)
          if (!existingIds.contains(p['id'])) p,
      ];
      if (fresh.isEmpty) {
        _page++;
        return true;
      }
      state = [...state, ...fresh];
      ref.read(postReactionsProvider.notifier).seedBatch(fresh);
      if (next.length < BackendDataSource.pageSize) _hasMore = false;
      _page++;
      return true;
    } finally {
      _busy = false;
    }
  }

  /// Inserts a created post at the top. With a backend the media is uploaded
  /// first and the remote post (with public urls) is inserted; otherwise the
  /// local-path post is used, so both modes show instantly (P3-2 acceptance).
  Future<void> addPost(Map<String, dynamic> post) async {
    final id = post['id'] as String?;
    if (id == null || id.isEmpty) return;
    final rawMedia = post['media'] as List? ?? [];
    if (rawMedia.isEmpty) return;
    final mediaPaths = [
      for (final m in rawMedia) '${(m as Map)['url'] ?? ''}',
    ];
    final remote = await ref
        .read(backendDataSourceProvider)
        .createPost(
          username: _me,
          caption: (post['caption'] as String?) ?? '',
          mediaPaths: mediaPaths,
        );
    final resolved = remote ?? post;
    state = [resolved, ...state];
    // Give the new post reaction state so like/save/repost work on its card.
    ref.read(postReactionsProvider.notifier).seedPost(resolved);
  }
}

final feedPostsProvider =
    NotifierProvider<FeedPostsStore, List<Map<String, dynamic>>>(
  FeedPostsStore.new,
);