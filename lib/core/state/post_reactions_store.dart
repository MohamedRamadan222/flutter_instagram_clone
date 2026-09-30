import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_instagram_clone/core/data/backend_data_source.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
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

  static const _fallback = PostReactions(
    liked: false,
    likes: 0,
    saved: false,
    reposted: false,
    reposts: 0,
    shares: 0,
  );

  static bool _asBool(dynamic value, bool fallback) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final v = value.toLowerCase().trim();
      if (v == 'true' || v == '1') return true;
      if (v == 'false' || v == '0' || v.isEmpty) return false;
    }
    return fallback;
  }

  static int _asInt(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  PostReactions of(String postId) => state[postId] ?? _fallback;

  void toggleLike(String postId) {
    final r = of(postId);
    state = {
      ...state,
      postId: r.copyWith(
        liked: !r.liked,
        likes: max(0, r.likes + (r.liked ? -1 : 1)),
      ),
    };
    // Phase 5: persist when a backend is configured (best-effort).
    ref.read(backendDataSourceProvider).togglePostLike(
          postId: postId,
          username: DummyData.currentUser['username'] as String,
          liked: r.liked,
        );
  }

  void toggleSave(String postId) {
    final r = of(postId);
    state = {...state, postId: r.copyWith(saved: !r.saved)};
    ref.read(backendDataSourceProvider).togglePostSave(
          postId: postId,
          username: DummyData.currentUser['username'] as String,
          saved: r.saved,
        );
  }

  /// Sets the saved flag outright, so the save sheet can write its selection
  /// back to the same store the feed bookmark reads (P2-2).
  void setSaved(String postId, bool saved) {
    final r = of(postId);
    if (r.saved == saved) return;
    state = {...state, postId: r.copyWith(saved: saved)};
    ref.read(backendDataSourceProvider).togglePostSave(
          postId: postId,
          username: DummyData.currentUser['username'] as String,
          saved: !saved,
        );
  }

  /// Registers a freshly created post (Phase 3) so the feed card has
  /// reaction state for it. No-op when the post is already known.
  void seedPost(Map<String, dynamic> post) {
    final id = post['id'] as String?;
    if (id == null || id.isEmpty) return;
    if (state.containsKey(id)) return;
    state = {
      ...state,
      id: PostReactions(
        liked: _asBool(post['liked'], false),
        likes: _asInt(post['likes'], 0),
        saved: _asBool(post['saved'], false),
        reposted: false,
        reposts: _asInt(post['reposts'], 0),
        shares: _asInt(post['shares'], 0),
      ),
    };
  }

  /// Seeds reaction state for a hydrated backend page (P5-3), keeping any
  /// session mutations that already happened.
  void seedBatch(List<Map<String, dynamic>> posts) {
    final next = <String, PostReactions>{};
    for (final post in posts) {
      final id = post['id'] as String?;
      if (id == null || id.isEmpty) continue;
      final existing = state[id];
      // Session mutations win for flags; backend wins for counts.
      // Accepts both `liked`/`saved` and legacy `id_liked`/`id_saved` keys.
      final liked = existing?.liked ??
          _asBool(post['liked'] ?? post['id_liked'], false);
      final saved = existing?.saved ??
          _asBool(post['saved'] ?? post['id_saved'], false);
      next[id] = PostReactions(
        liked: liked,
        likes: _asInt(post['likes'], existing?.likes ?? 0),
        saved: saved,
        reposted: existing?.reposted ?? false,
        reposts: _asInt(post['reposts'], existing?.reposts ?? 0),
        shares: _asInt(post['shares'], existing?.shares ?? 0),
      );
    }
    state = {...state, ...next};
  }

  void toggleRepost(String postId) {
    final r = of(postId);
    state = {
      ...state,
      postId: r.copyWith(
        reposted: !r.reposted,
        reposts: max(0, r.reposts + (r.reposted ? -1 : 1)),
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