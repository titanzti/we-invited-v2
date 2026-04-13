import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/post_repository.dart';
import 'feed_controller.dart'; // To invalidate feed

part 'create_event_controller.g.dart';

@riverpod
class CreateEventController extends _$CreateEventController {
  @override
  FutureOr<void> build() {
    // Initial state is devoid of action
  }

  Future<bool> createEvent({
    required String title,
    required String location,
    required String category,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(postRepositoryProvider);
      await repository.createPost(title, location, category);
      
      // Invalidate the feed so it refreshes natively over API
      ref.invalidate(feedControllerProvider);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
