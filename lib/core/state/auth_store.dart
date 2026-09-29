import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Session state for this device (P4-1, P4-3).
///
/// Persisted locally so a cold start respects the last session. The restore
/// happens asynchronously on first build; the splash screen holds the boot
/// gate long enough for it to land before routing.
class AuthStore extends Notifier<bool> {
  static const _sessionKey = 'auth_logged_in';

  @override
  bool build() {
    _restoreSession();
    return false;
  }

  Future<void> _restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_sessionKey) ?? false) state = true;
    } catch (_) {
      // no storage available (e.g. tests without a preference mock): stay out
    }
  }

  Future<void> login() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_sessionKey, true);
    } catch (_) {}
    state = true;
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_sessionKey, false);
    } catch (_) {}
    state = false;
  }
}

final authProvider = NotifierProvider<AuthStore, bool>(AuthStore.new);