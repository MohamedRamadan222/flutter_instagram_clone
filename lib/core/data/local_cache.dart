import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Tiny JSON cache over [SharedPreferences] for offline reads (P5-3).
///
/// Each key is a `table_page` scope; the backend data source writes the last
/// successful fetch and falls back to it when the network is unavailable, so
/// the app "shows cache" in airplane mode.
class LocalCache {
  static const _prefix = 'backend_cache_';

  Future<List<Map<String, dynamic>>?> read(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('$_prefix$key');
      if (raw == null) return null;
      final decoded = jsonDecode(raw) as List;
      return [
        for (final item in decoded) Map<String, dynamic>.from(item as Map),
      ];
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String key, List<Map<String, dynamic>> rows) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_prefix$key', jsonEncode(rows));
    } catch (_) {
      // cache is best-effort
    }
  }
}