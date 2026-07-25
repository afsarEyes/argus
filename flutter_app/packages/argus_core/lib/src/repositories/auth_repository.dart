import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/user.dart';
import '../services/supabase_client_provider.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<User?> loginWithPin(String pin);
  Future<void> logout();
  Stream<User?> get currentUserStream;
  User? get currentUser;
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);
  final supabase.SupabaseClient _client;

  @override
  Future<User?> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(email: email, password: password);
    if (response.user != null) {
      return _fetchUserProfile(response.user!.id);
    }
    return null;
  }

  @override
  Future<User?> loginWithPin(String pin) async {
    // In PIN-login, we map the PIN to the user profile email and authenticate.
    // For schema simplicity, we query public.users where pin column matches or simulate authenticating.
    // Since we don't have a database pin column yet, we throw an error or mock it for local testing.
    throw UnimplementedError('PIN login requires backend configuration.');
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  @override
  User? get currentUser {
    final user = _client.auth.currentUser;
    if (user != null) {
      // Return a temporary user until stream fetches full profile.
      return null;
    }
    return null;
  }

  @override
  Stream<User?> get currentUserStream {
    return _client.auth.onAuthStateChange.asyncMap((state) async {
      final user = state.session?.user;
      if (user != null) {
        return _fetchUserProfile(user.id);
      }
      return null;
    });
  }

  Future<User?> _fetchUserProfile(String userId) async {
    try {
      final data = await _client.from('users').select().eq('id', userId).maybeSingle();
      if (data != null) {
        return User.fromJson(data);
      }
    } catch (_) {}
    return null;
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepository(client);
}
