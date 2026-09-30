/// Backend wiring (Phase 5).
///
/// The app runs fully on dummy data when no Supabase project is configured.
/// To enable the backend, run with:
/// `flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
/// See `docs/full_app_plan/06_BACKEND.md` for the setup runbook.
class AppConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get hasBackend =>
      supabaseUrl.trim().startsWith('http') &&
      supabaseAnonKey.trim().isNotEmpty;
}