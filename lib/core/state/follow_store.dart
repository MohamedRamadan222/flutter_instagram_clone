import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_instagram_clone/core/utils/dummy_suggested_user.dart';
import 'package:flutter_instagram_clone/core/utils/post_dummy_data.dart';
import 'package:flutter_instagram_clone/core/utils/reel_dummy_data.dart';

/// Session-wide follow state, keyed by username.
///
/// Every follow button (suggested users, profile, reels pill, post header)
/// reads and writes this one map so the same user follows/unfollows
/// consistently everywhere (P2-2, P2-4).
class FollowStore extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    final map = <String, bool>{};
    for (final post in PostDummyData.posts) {
      map.putIfAbsent(
        post['username'] as String,
        () => post['isFollowing'] == true,
      );
    }
    for (final reel in ReelDummyData.reels) {
      map.putIfAbsent(
        reel['username'] as String,
        () => reel['isFollowing'] == true,
      );
    }
    // Suggested-user model defaults fill in anyone not covered above, so the
    // store and the model agree from the start (P2-4).
    for (final user in dummySuggestedUsers) {
      map.putIfAbsent(user.username, () => user.isFollowing);
    }
    return map;
  }

  bool isFollowing(String username) => state[username] ?? false;

  void toggle(String username) {
    state = {...state, username: !isFollowing(username)};
  }
}

final followProvider =
    NotifierProvider<FollowStore, Map<String, bool>>(FollowStore.new);