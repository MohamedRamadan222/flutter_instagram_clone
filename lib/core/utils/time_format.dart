import 'package:timeago/timeago.dart' as timeago;

/// Stable "x ago" formatting for backend timestamps (P6-4).
///
/// Never throws: any unparseable input degrades to "just now".
String formatTimeAgo(DateTime created, {DateTime? now}) {
  try {
    final clock = now ?? DateTime.now();
    // Sub-minute gaps read as "just now" in the UI spec.
    if ((clock.difference(created).abs() < const Duration(minutes: 1))) {
      return 'just now';
    }
    final formatted = timeago.format(created, clock: clock);
    if (formatted == 'a moment ago') return 'just now';
    return formatted;
  } catch (_) {
    return 'just now';
  }
}