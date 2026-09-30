import 'package:flutter/foundation.dart';

// P7-3: Analytics event kinds logged to the `analytics_events` table.
enum AnalyticsEvent {
  // P7-3: App cold/warm start, logged once per foreground.
  appOpen,
  // P7-3: Like toggled on a post/reel (see PostReactionsStore.toggleLike).
  like,
  // P7-3: New post published (see FeedPostsStore.addPost).
  post,
  // P7-3: Follow toggled on a user (see FollowStore.toggle).
  follow,
}

// P7-3: Maps each AnalyticsEvent to its `analytics_events.event` SQL string.
extension AnalyticsEventName on AnalyticsEvent {
  // P7-3: SQL wire value for this event ('app_open', 'like', 'post', 'follow').
  String get eventName {
    switch (this) {
      case AnalyticsEvent.appOpen:
        return 'app_open';
      case AnalyticsEvent.like:
        return 'like';
      case AnalyticsEvent.post:
        return 'post';
      case AnalyticsEvent.follow:
        return 'follow';
    }
  }
}

// P7-3: Best-effort Supabase event logger; no-ops without a client, never throws.
class AnalyticsService {
  // P7-3: Optional Supabase client kept as dynamic so tests run without backend deps.
  dynamic _client;

  // P7-3: Creates the service with an optional client (null = no-op mode).
  AnalyticsService({dynamic supabaseClient}) : _client = supabaseClient;

  // P7-3: Attaches (or detaches with null) the Supabase client after construction.
  void configure(dynamic client) {
    _client = client;
  }

  // P7-3: Whether a backend client is attached and events will be sent.
  bool get hasClient => _client != null;

  // P7-3: Logs an event row; debugPrints and returns when unconfigured, never throws.
  Future<void> log(
    AnalyticsEvent event, {
    String? userId,
    Map<String, dynamic>? payload,
  }) async {
    final client = _client;
    if (client == null) {
      debugPrint(
        'analytics (no backend configured): ${event.eventName} '
        'user=$userId payload=${payload ?? const {}}',
      );
      return;
    }
    try {
      await client.from('analytics_events').insert({
        'user_id': userId,
        'event': event.eventName,
        'payload': payload ?? const {},
      });
    } catch (e) {
      // Best-effort only: analytics must never break the user action.
      debugPrint('analytics failed: $e');
    }
  }
}

// P7-3: Global singleton call sites use (stores call analytics.log(...)).
final analytics = AnalyticsService();
