import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/api_client.dart';
import '../domain/user_model.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ApiClient.instance);
}

/// A lightweight representation of the current Session State
/// Instead of a real-time Stream like Firebase, we use an AsyncValue pattern 
/// in Riverpod to track if the user is authenticated.
@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  FutureOr<UserModel?> build() async {
    // Attempt to automatically authenticate by fetching /auth/me on app load
    return await ref.read(authRepositoryProvider).initAuth();
  }

  void setUser(UserModel? user) {
    state = AsyncData(user);
  }
}

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  /// Startup routine checking for saved JWTs.
  Future<UserModel?> initAuth() async {
    final token = await ApiClient.storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) return null;

    try {
      final response = await _dio.get('/auth/me');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      }
    } catch (e) {
      // Token is invalid or expired. Clear it.
      await ApiClient.storage.delete(key: 'jwt_token');
    }
    return null;
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
    });

    if (response.statusCode == 200) {
      final token = response.data['token'];
      await ApiClient.storage.write(key: 'jwt_token', value: token);
    } else {
      throw Exception(response.data['error'] ?? 'Registration failed');
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final token = response.data['token'];
      await ApiClient.storage.write(key: 'jwt_token', value: token);
    } else {
      throw Exception(response.data['error'] ?? 'Login failed');
    }
  }

  Future<void> signOut() async {
    await ApiClient.storage.delete(key: 'jwt_token');
  }
}
