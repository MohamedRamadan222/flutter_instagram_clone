// P7-3 analytics service tests (Supabase events only, no backend required).

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_instagram_clone/core/utils/analytics_service.dart';

void main() {
  test('no-op without client never throws', () async {
    final service = AnalyticsService();
    expect(service.hasClient, isFalse);
    await expectLater(
      service.log(AnalyticsEvent.appOpen, userId: 'alice'),
      completes,
    );
    await expectLater(
      service.log(
        AnalyticsEvent.like,
        userId: 'alice',
        payload: {'postId': 'p1'},
      ),
      completes,
    );
  });

  test('event-name mapping matches analytics_events check constraint', () {
    expect(AnalyticsEvent.appOpen.eventName, 'app_open');
    expect(AnalyticsEvent.like.eventName, 'like');
    expect(AnalyticsEvent.post.eventName, 'post');
    expect(AnalyticsEvent.follow.eventName, 'follow');
  });

  test('singleton exists and starts unconfigured', () {
    expect(analytics, isA<AnalyticsService>());
    expect(analytics.hasClient, isFalse);
  });
}
