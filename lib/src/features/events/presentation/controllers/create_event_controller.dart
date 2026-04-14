import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/post_repository.dart';
import 'feed_controller.dart';

part 'create_event_controller.g.dart';

@riverpod
class CreateEventController extends _$CreateEventController {
  @override
  FutureOr<void> build() {}

  Future<bool> createEvent({
    required String title,
    required String location,
    required String category,
    String? description,
    DateTime? startDateTime,
    DateTime? endDateTime,
    int? maxCapacity,
    bool requiresApproval = false,
    double? latitude,
    double? longitude,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(postRepositoryProvider);
      await repository.createPost(
        title: title,
        location: location,
        category: category,
        description: description,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        maxCapacity: maxCapacity,
        requiresApproval: requiresApproval,
        latitude: latitude,
        longitude: longitude,
      );

      ref.invalidate(feedControllerProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
