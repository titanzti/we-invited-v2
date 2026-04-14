import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/rsvp_repository.dart';
import '../domain/rsvp_model.dart';
import '../domain/notification_prefs_model.dart';

final rsvpControllerProvider = AsyncNotifierProvider<RSVPController, void>(() {
  return RSVPController();
});

class RSVPController extends AsyncNotifier<RSVPController> {
  late final RSVPRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.watch(rsvpRepositoryProvider);
  }

  Future<void> submitRSVP({
    required String eventId,
    required RSVPStatus status,
    int guestCount = 0,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.submitRSVP(
        eventId: eventId,
        status: status,
        guestCount: guestCount,
        note: note,
      );
    });
  }

  Future<RSVPStats> getEventRSVPStats(String eventId) async {
    return _repository.getEventRSVPStats(eventId);
  }

  Future<List<RSVPModel>> getMyRSVPs() async {
    return _repository.getMyRSVPs();
  }

  Future<NotificationPrefsModel> getNotificationPrefs() async {
    return _repository.getNotificationPrefs();
  }

  Future<void> updateNotificationPrefs(NotificationPrefsModel prefs) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateNotificationPrefs(prefs);
    });
  }
}
