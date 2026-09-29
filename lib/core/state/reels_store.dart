import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_instagram_clone/core/utils/reel_dummy_data.dart';

/// The reels list for this session (Phase 3).
///
/// Seeded from [ReelDummyData.reels]; `addReel` inserts a created reel at the
/// top so it is visible immediately without a restart (P3-4 acceptance).
class ReelsStore extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() => List.of(ReelDummyData.reels);

  void addReel(Map<String, dynamic> reel) {
    state = [reel, ...state];
  }
}

final reelsProvider =
    NotifierProvider<ReelsStore, List<Map<String, dynamic>>>(ReelsStore.new);