import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            email: email,
            password: password,
          );
      // Fetch profile and update Global state
      final user = await ref.read(authRepositoryProvider).initAuth();
      ref.read(authStateProvider.notifier).setUser(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      // Depending on app logic we can throw this further to UI
      rethrow;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).createUserWithEmailAndPassword(
            email: email,
            password: password,
            name: name,
          );
      // Immediately set the session
      final user = await ref.read(authRepositoryProvider).initAuth();
      ref.read(authStateProvider.notifier).setUser(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    ref.read(authStateProvider.notifier).setUser(null);
  }
}
