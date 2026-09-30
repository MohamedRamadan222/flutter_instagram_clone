/// P6-3: single autoplay / mute policy.
///
/// - Feed inline videos: muted autoplay, tap the speaker to unmute one player.
/// - Reels: muted autoplay, tap the speaker to unmute one player.
/// - Any player pauses when < [visibilityThreshold] visible, when its tab is
///   hidden (fraction 0), or when the app is backgrounded.
abstract final class AutoplayPolicy {
  /// Fraction of the player that must be visible to play.
  static const double visibilityThreshold = 0.5;

  /// All players start muted; unmute is per-player via the speaker button.
  static const bool defaultMuted = true;

  /// Feed and reels both autoplay when visible.
  static const bool feedAutoplay = true;
  static const bool reelsAutoplay = true;
}
