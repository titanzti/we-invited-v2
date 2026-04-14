import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/api_client.dart';
import '../domain/rsvp_model.dart';
import '../domain/notification_prefs_model.dart';

part 'rsvp_repository.g.dart';

@Riverpod(keepAlive: true)
RSVPRepository rsvpRepository(RSVPRepositoryRef ref) {
  return RSVPRepository();
}

class RSVPRepository {
  RSVPRepository();

  Future<RSVPModel> submitRSVP({
    required String eventId,
    required RSVPStatus status,
    int guestCount = 0,
    String? note,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        '/rsvp/$eventId',
        data: {
          'status': status.name.toUpperCase(),
          'guestCount': guestCount,
          if (note != null && note.isNotEmpty) 'note': note,
        },
      );
      return RSVPModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to submit RSVP: $e');
    }
  }

  Future<List<RSVPModel>> getEventRSVPs(String eventId) async {
    try {
      final response = await ApiClient.instance.get('/rsvp/$eventId');
      final data = response.data['data'] as List;
      return data.map((json) => RSVPModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load RSVPs: $e');
    }
  }

  Future<RSVPStats> getEventRSVPStats(String eventId) async {
    try {
      final response = await ApiClient.instance.get('/rsvp/$eventId');
      return RSVPStats.fromJson(response.data['stats'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load RSVP stats: $e');
    }
  }

  Future<List<RSVPModel>> getMyRSVPs() async {
    try {
      final response = await ApiClient.instance.get('/rsvp/my');
      final data = response.data['data'] as List;
      return data.map((json) => RSVPModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load my RSVPs: $e');
    }
  }

  Future<List<Map<String, dynamic>>> sendInvites(String eventId, List<String> inviteeIds) async {
    try {
      final response = await ApiClient.instance.post(
        '/rsvp/invite/$eventId',
        data: {'inviteeIds': inviteeIds},
      );
      return (response.data['data'] as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to send invites: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getMyInvites() async {
    try {
      final response = await ApiClient.instance.get('/rsvp/invite/my');
      return (response.data['data'] as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to load invites: $e');
    }
  }

  Future<Map<String, dynamic>> respondToInvite(String inviteId, String action) async {
    try {
      final response = await ApiClient.instance.patch(
        '/rsvp/invite/$inviteId',
        data: {'action': action},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to respond to invite: $e');
    }
  }

  Future<NotificationPrefsModel> getNotificationPrefs() async {
    try {
      final response = await ApiClient.instance.get('/rsvp/notification-prefs');
      return NotificationPrefsModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to load notification preferences: $e');
    }
  }

  Future<NotificationPrefsModel> updateNotificationPrefs(NotificationPrefsModel prefs) async {
    try {
      final response = await ApiClient.instance.patch(
        '/rsvp/notification-prefs',
        data: prefs.toJson(),
      );
      return NotificationPrefsModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception('Failed to update notification preferences: $e');
    }
  }
}
