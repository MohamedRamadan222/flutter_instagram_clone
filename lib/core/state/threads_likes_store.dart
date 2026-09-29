import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Liked-thread ids for this session (P2-2). Keyed by the stable `id` added
/// to `threads_dummy_data.dart` in Phase 2 (`thread_N`).
class ThreadsLikesStore extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  bool isLiked(String key) => state.contains(key);

  void toggle(String key) {
    final next = {...state};
    if (!next.remove(key)) {
      next.add(key);
    }
    state = next;
  }
}

final threadsLikesProvider =
    NotifierProvider<ThreadsLikesStore, Set<String>>(ThreadsLikesStore.new);