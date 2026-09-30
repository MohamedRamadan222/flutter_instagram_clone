import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Liked-reel ids for this session (P2-2). Reels already carry stable `id`s.
class ReelsLikesStore extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  bool isLiked(String id) => state.contains(id);

  void toggle(String id) {
    if (id.isEmpty) return;
    final next = {...state};
    if (!next.remove(id)) {
      next.add(id);
    }
    state = next;
  }
}

final reelsLikesProvider =
    NotifierProvider<ReelsLikesStore, Set<String>>(ReelsLikesStore.new);