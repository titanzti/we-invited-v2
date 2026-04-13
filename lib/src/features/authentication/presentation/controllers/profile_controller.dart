import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'auth_controller.dart';

part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserModel?> build() async {
    // Watch current auth user
    final authUser = ref.watch(authControllerProvider).value;
    final email = authUser?.email;

    if (email == null || email.isEmpty) {
      return null;
    }

    return ref.watch(userRepositoryProvider).getProfile(email);
  }

  Future<void> updateProfile({
    required String name,
    required String gender,
  }) async {
    final user = state.value;
    if (user == null || user.email == null) return;
    
    state = const AsyncValue.loading();

    try {
      await ref.read(userRepositoryProvider).updateProfile(
        email: user.email!,
        name: name,
        gender: gender,
      );
      // Refresh the provider
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfilePhoto(File imageFile) async {
    final user = state.value;
    if (user == null || user.email == null) return;

    state = const AsyncValue.loading();
    try {
      await ref.read(userRepositoryProvider).updateProfilePhoto(
        user.email!,
        user.uid,
        imageFile,
      );
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
