import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController {
  LoginController({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<String?> login(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return null;
    } on AuthException catch (error) {
      return error.message;
    } catch (_) {
      return 'Unable to sign in. Please try again.';
    }
  }

  Future<void> logout() => _client.auth.signOut();

  bool get hasActiveSession => _client.auth.currentSession != null;
}
