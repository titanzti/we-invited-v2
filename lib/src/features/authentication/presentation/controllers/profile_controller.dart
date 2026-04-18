import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/user_model.dart';
import '../../data/user_repository.dart';
import '../../data/auth_repository.dart';

part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserModel?> build() async {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    if (user == null) return null;

    return user;
  }

  Future<void> updateProfile({
    required String name,
    String? gender,
  }) async {
    state = const AsyncValue.loading();

    try {
      final updated = await ref.read(userRepositoryProvider).updateProfile(
        name: name,
        gender: gender,
      );
      ref.read(authStateProvider.notifier).setUser(updated);
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfilePhoto(File imageFile) async {
    state = const AsyncValue.loading();
    try {
      final photoUrl = await ref.read(userRepositoryProvider).updateProfilePhoto(imageFile);
      final current = state.value;
      if (current != null) {
        final updated = UserModel(
          uid: current.uid,
          email: current.email,
          name: current.name,
          gender: current.gender,
          profilePhoto: photoUrl,
        );
        ref.read(authStateProvider.notifier).setUser(updated);
      }
      ref.invalidateSelf();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
