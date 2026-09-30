// Session store behavior (P2), tested without widgets (P6-4).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_instagram_clone/core/state/follow_store.dart';
import 'package:flutter_instagram_clone/core/state/post_reactions_store.dart';

void main() {
  group('PostReactionsStore', () {
    late ProviderContainer container;
    late PostReactionsStore store;

    setUp(() {
      container = ProviderContainer();
      store = container.read(postReactionsProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('seeds all dummy posts with their counts', () {
      final state = container.read(postReactionsProvider);
      expect(state.length, greaterThanOrEqualTo(8));
      expect(state['post_1']!.liked, isFalse);
      expect(state['post_1']!.likes, greaterThan(0));
    });

    test('like toggles count and liked flag together', () {
      final before = store.of('post_1');
      store.toggleLike('post_1');
      final liked = store.of('post_1');
      expect(liked.liked, isTrue);
      expect(liked.likes, before.likes + 1);
      store.toggleLike('post_1');
      expect(store.of('post_1').liked, isFalse);
      expect(store.of('post_1').likes, before.likes);
    });

    test('repost toggles the flag and the count (review regression)', () {
      store.toggleRepost('post_1');
      expect(store.of('post_1').reposted, isTrue);
      expect(store.of('post_1').reposts, 13); // 12 + 1
      store.toggleRepost('post_1');
      expect(store.of('post_1').reposted, isFalse);
      expect(store.of('post_1').reposts, 12);
    });

    test('save toggles and setSaved writes through', () {
      store.toggleSave('post_1');
      expect(store.of('post_1').saved, isTrue);
      store.setSaved('post_1', false);
      expect(store.of('post_1').saved, isFalse);
    });

    test('seedPost adds reaction state for a brand new post', () {
      store.seedPost({
        'id': 'new_post',
        'likes': 3,
        'reposts': 1,
        'shares': 0,
      });
      final r = store.of('new_post');
      expect(r.likes, 3);
      expect(r.reposts, 1);
      expect(r.liked, isFalse);
    });

    test('seedBatch keeps existing session mutations', () {
      store.toggleLike('post_2');
      final likedBefore = store.of('post_2').liked;
      store.seedBatch([
        {'id': 'post_2', 'likes': 999, 'liked': false},
      ]);
      expect(store.of('post_2').liked, likedBefore);
      expect(store.of('post_2').likes, 999);
    });
  });

  group('FollowStore', () {
    late ProviderContainer container;

    setUp(() => container = ProviderContainer());
    tearDown(() => container.dispose());

    test('seeds follow state from posts, reels and suggested users', () {
      final follows = container.read(followProvider);
      // post_2's author is following: true in the dummy feed
      expect(follows['omar.khaled'], isTrue);
      // suggested users seed their model defaults
      expect(follows.containsKey('mohamed.ahmed'), isTrue);
      expect(follows['mohamed.ahmed'], isFalse);
    });

    test('toggle flips and is shared across reads', () {
      final store = container.read(followProvider.notifier);
      expect(store.isFollowing('mohamed.ahmed'), isFalse);
      store.toggle('mohamed.ahmed');
      expect(store.isFollowing('mohamed.ahmed'), isTrue);
      store.toggle('mohamed.ahmed');
      expect(store.isFollowing('mohamed.ahmed'), isFalse);
    });
  });
}