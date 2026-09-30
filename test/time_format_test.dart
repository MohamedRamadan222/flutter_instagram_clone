// Time formatting used by backend data (P6-4).

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_instagram_clone/core/utils/time_format.dart';

void main() {
  test('now formats as "just now"', () {
    final now = DateTime(2026, 9, 29, 12);
    expect(formatTimeAgo(now, now: now), 'just now');
  });

  test('two hours ago formats with the unit', () {
    final now = DateTime(2026, 9, 29, 12);
    final twoHoursAgo = now.subtract(const Duration(hours: 2));
    expect(formatTimeAgo(twoHoursAgo, now: now), '2 hours ago');
  });

  test('longer gaps use days', () {
    final now = DateTime(2026, 9, 29, 12);
    final threeDaysAgo = now.subtract(const Duration(days: 3));
    expect(formatTimeAgo(threeDaysAgo, now: now), contains('3 days'));
  });

  test('never throws (graceful fallback)', () {
    expect(() => formatTimeAgo(DateTime(0)), returnsNormally);
  });
}