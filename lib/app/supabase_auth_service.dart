import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final supabase = Supabase.instance.client;

  // Login function
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final profile = await supabase
          .from('profiles')
          .select()
          .eq('email', email)
          .single();

      if (profile == null) {
        return 'User profile not found.';
      }

      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Login failed: ${e.toString()}';
    }
  }

  // Sign up function
  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return 'User creation failed.';
      }

      await supabase.from('profiles').upsert({
        'id': res.user!.id,
        'email': email,
        'full_name': fullName,
        'updated_at': DateTime.now().toIso8601String(),
      });

      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Signup failed: ${e.toString()}';
    }
  }

  // Sign out function
  Future<String?> signOut() async {
    try {
      await supabase.auth.signOut();
      return null; // Success
    } catch (e) {
      return 'Sign out failed: ${e.toString()}';
    }
  }

  // Get full name of current user from profiles table
  Future<String?> getFullName() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return null; // User not logged in
      }

      final response = await supabase
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .single();

      if (response == null || response['full_name'] == null) {
        return null; // No name found
      }

      return response['full_name'] as String;
    } catch (e) {
      return null;
    }
  }
}
