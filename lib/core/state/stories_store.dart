import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_instagram_clone/core/data/backend_data_source.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_data.dart';
import 'package:flutter_instagram_clone/core/utils/stories_dummy_data.dart';

/// The story strip for this session (Phase 3).
///
/// A leading "Your story" entry carries the current user's posts; publishing
/// appends a picked image to it (`publishStory`) so it shows up in the strip
/// immediately (P3-3 acceptance).
class StoriesStore extends Notifier<List<Map<String, dynamic>>> {
  static Map<String, dynamic> yourStoryEntry() => {
        'userName': 'Your story',
        'username': 'me',
        'profileImage': DummyData.currentUser['profilePic'],
        'hasStory': false,
        'isSeen': false,
        'stories': <Map<String, dynamic>>[],
      };

  @override
  List<Map<String, dynamic>> build() {
    return [yourStoryEntry(), ...StoriesDummyData.stories];
  }

  /// Phase 5: replaces the strip with backend stories when configured.
  Future<bool> hydrate() async {
    final stories =
        await ref.read(backendDataSourceProvider).fetchStories();
    if (stories == null) return false;
    state = [yourStoryEntry(), ...stories];
    return true;
  }

  void publishStory(String imagePath) {
    final entry = state.first;
    final stories = List<Map<String, dynamic>>.from(entry['stories'] as List)
      ..add({'imageUrl': imagePath});
    state = [
      {
        ...entry,
        'hasStory': stories.isNotEmpty,
        'stories': stories,
      },
      ...state.skip(1),
    ];
    // Phase 5: also upload when a backend is configured (best-effort).
    ref
        .read(backendDataSourceProvider)
        .publishStory(
          username: DummyData.currentUser['username'] as String,
          imagePath: imagePath,
        );
  }
}

final storiesProvider =
    NotifierProvider<StoriesStore, List<Map<String, dynamic>>>(
  StoriesStore.new,
);