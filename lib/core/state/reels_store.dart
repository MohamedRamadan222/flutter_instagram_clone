import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_instagram_clone/core/data/backend_data_source.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_instagram_clone/core/utils/reel_dummy_data.dart';

/// The reels list for this session (Phase 3).
///
/// Seeded from [ReelDummyData.reels]; with a backend configured (Phase 5) it
/// hydrates from Supabase (`hydrate`) with offline cache fallback.
class ReelsStore extends Notifier<List<Map<String, dynamic>>> {
  @override
  List<Map<String, dynamic>> build() => [
        for (final r in ReelDummyData.reels) Map<String, dynamic>.of(r),
      ];

  /// Phase 5: replaces the list with backend reels when configured.
  Future<bool> hydrate() async {
    final reels = await ref.read(backendDataSourceProvider).fetchReels();
    if (reels == null || reels.isEmpty) return false;
    state = reels;
    return true;
  }

  Future<void> addReel(Map<String, dynamic> reel) async {
    final videoPath = reel['videoUrl'] as String? ?? '';
    if (videoPath.isEmpty) return;
    final remote = await ref
        .read(backendDataSourceProvider)
        .createReel(
          username: DummyData.currentUser['username'] as String,
          videoPath: videoPath,
          caption: (reel['caption'] as String?) ?? '',
        );
    state = [remote ?? reel, ...state];
  }
}

final reelsProvider =
    NotifierProvider<ReelsStore, List<Map<String, dynamic>>>(ReelsStore.new);