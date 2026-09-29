import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Liked-thread keys for this session (P2-2). Key shape: `username|timeAgo`,
/// since threads have no stable id yet.
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