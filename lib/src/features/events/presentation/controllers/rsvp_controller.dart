import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/rsvp_repository.dart';
import '../../domain/rsvp_model.dart';
import '../../domain/notification_prefs_model.dart';
import '../../domain/invite_model.dart';
import 'feed_controller.dart';

final rsvpControllerProvider = AsyncNotifierProvider<RSVPController, void>(() {
  return RSVPController();
});

class RSVPController extends AsyncNotifier<void> {
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
      ref.invalidate(feedControllerProvider);
    });
  }

  Future<void> cancelRSVP(String eventId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.cancelRSVP(eventId);
      ref.invalidate(feedControllerProvider);
    });
  }

  Future<RSVPStats> getEventRSVPStats(String eventId) async {
    return _repository.getEventRSVPStats(eventId);
  }

  Future<RSVPModel?> getMyRSVP(String eventId) async {
    return _repository.getMyRSVP(eventId);
  }

  Future<List<RSVPModel>> getMyRSVPs() async {
    return _repository.getMyRSVPs();
  }

  Future<List<RSVPModel>> getEventRSVPs(String eventId) async {
    return _repository.getEventRSVPs(eventId);
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

  Future<List<InviteModel>> sendInvites(
    String eventId,
    List<String> inviteeIds,
  ) async {
    return _repository.sendInvites(eventId, inviteeIds);
  }

  Future<List<RSVPUserModel>> searchUsers(String query) async {
    return _repository.searchUsers(query);
  }

  Future<List<InviteModel>> getMyInvites() async {
    return _repository.getMyInvites();
  }

  Future<InviteModel> respondToInvite(String inviteId, String action) async {
    return _repository.respondToInvite(inviteId, action);
  }
}
