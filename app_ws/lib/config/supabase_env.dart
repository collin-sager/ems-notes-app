import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseEnv {
  SupabaseEnv._();

  static String get url => _read('SUPABASE_URL');

  static String get anonKey => _read('SUPABASE_ANON_KEY');

  static String _read(String key) {
    String fromDefine = '';
    if (key == 'SUPABASE_URL') {
      fromDefine = const String.fromEnvironment('SUPABASE_URL');
    } else if (key == 'SUPABASE_ANON_KEY') {
      fromDefine = const String.fromEnvironment('SUPABASE_ANON_KEY');
    }
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }
    return dotenv.env[key] ?? '';
  }

  static void ensureConfigured() {
    if (url.isEmpty || anonKey.isEmpty) {
      throw StateError(
        'Supabase environment variables are missing. Define SUPABASE_URL and SUPABASE_ANON_KEY in .env or pass them via --dart-define.',
      );
    }
  }
}
