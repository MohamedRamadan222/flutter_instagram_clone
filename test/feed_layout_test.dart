// Feed insertion math (P0-3, P6-4): sections land on their slots and post
// indices shift past the inserted sections without collisions.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_instagram_clone/core/utils/feed_layout.dart';

void main() {
  // realistic feed: 8 posts, suggested at slot 1, threads at slot 3
  const suggested = 1;
  const threads = 3;

  test('special sections occupy their slots', () {
    expect(feedSlotIndex(suggested, suggestedIndex: suggested, threadsIndex: threads),
        feedSlotSuggested);
    expect(feedSlotIndex(threads, suggestedIndex: suggested, threadsIndex: threads),
        feedSlotThreads);
  });

  test('posts before any section map 1:1', () {
    expect(feedSlotIndex(0, suggestedIndex: suggested, threadsIndex: threads), 0);
  });

  test('posts between the sections shift by one', () {
    // slot 2 sits after suggested(1), before threads(3) -> post 1
    expect(feedSlotIndex(2, suggestedIndex: suggested, threadsIndex: threads), 1);
  });

  test('posts after both sections shift by two', () {
    expect(feedSlotIndex(4, suggestedIndex: suggested, threadsIndex: threads), 2);
    expect(feedSlotIndex(9, suggestedIndex: suggested, threadsIndex: threads), 7);
  });

  test('distinct slot indices never resolve to the same post', () {
    final seen = <int>{};
    for (var i = 0; i < 12; i++) {
      final slot = feedSlotIndex(i, suggestedIndex: suggested, threadsIndex: threads);
      if (slot >= 0) {
        expect(seen.add(slot), isTrue, reason: 'slot $i collides');
      } else {
        expect(slot, anyOf(feedSlotSuggested, feedSlotThreads));
      }
    }
  });

  test('caller still guards against the current post count', () {
    final posts = List.filled(8, {});
    for (var i = 0; i < 20; i++) {
      final slot = feedSlotIndex(i, suggestedIndex: suggested, threadsIndex: threads);
      if (slot >= 0) {
        final inRange = slot < posts.length;
        // slot 9 is the eighth post; anything beyond is the guard's job
        expect(inRange, i <= 9);
      }
    }
  });

  test('total slots = posts + the two sections', () {
    expect(feedSlotCount(8), 10);
    expect(feedSlotCount(0), 2);
  });
}