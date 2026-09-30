// P6-3: autoplay / mute policy guardrails.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_instagram_clone/core/utils/autoplay_policy.dart';

void main() {
  test('players start muted and autoplay when visible', () {
    expect(AutoplayPolicy.defaultMuted, isTrue);
    expect(AutoplayPolicy.feedAutoplay, isTrue);
    expect(AutoplayPolicy.reelsAutoplay, isTrue);
  });

  test('visibility threshold is strict enough to pause offscreen players', () {
    expect(AutoplayPolicy.visibilityThreshold, greaterThanOrEqualTo(0.5));
    expect(AutoplayPolicy.visibilityThreshold, lessThanOrEqualTo(0.8));
  });
}
