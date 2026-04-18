import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/api_client.dart';
import '../../../utils/api_response.dart';
import '../domain/rsvp_model.dart';
import '../domain/notification_prefs_model.dart';
import '../domain/invite_model.dart';
import 'rsvp_list_response.dart';

part 'rsvp_repository.g.dart';

@Riverpod(keepAlive: true)
RSVPRepository rsvpRepository(RsvpRepositoryRef ref) {
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
      final result = ApiResponse<RSVPModel>.fromJson(
        response.data,
        (data) => RSVPModel.fromJson(data),
      );
      return result.data!;
    } catch (e) {
      throw Exception('Failed to submit RSVP: $e');
    }
  }

  Future<List<RSVPModel>> getEventRSVPs(String eventId) async {
    try {
      final response = await ApiClient.instance.get('/rsvp/$eventId');
      final result = RsvpListResponse.fromJson(response.data);
      return result.data ?? [];
    } catch (e) {
      throw Exception('Failed to load RSVPs: $e');
    }
  }

  Future<RSVPModel?> getMyRSVP(String eventId) async {
    try {
      final response = await ApiClient.instance.get('/rsvp/$eventId/me');
      final result = ApiResponse<RSVPModel>.fromJson(
        response.data,
        (data) => RSVPModel.fromJson(data),
      );
      return result.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw Exception('Failed to load your RSVP: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load your RSVP: $e');
    }
  }

  Future<RSVPStats> getEventRSVPStats(String eventId) async {
    try {
      final response = await ApiClient.instance.get('/rsvp/$eventId');
      final result = RsvpListResponse.fromJson(response.data);
      return result.stats ?? const RSVPStats();
    } catch (e) {
      throw Exception('Failed to load RSVP stats: $e');
    }
  }

  Future<List<RSVPModel>> getMyRSVPs() async {
    try {
      final response = await ApiClient.instance.get('/rsvp/my');
      final result = ApiResponse<List<RSVPModel>>.fromJson(
        response.data,
        (data) => List<RSVPModel>.from(
          (data as List).map((x) => RSVPModel.fromJson(x)),
        ),
      );
      return result.data ?? [];
    } catch (e) {
      throw Exception('Failed to load my RSVPs: $e');
    }
  }

  Future<List<InviteModel>> sendInvites(String eventId, List<String> inviteeIds) async {
    try {
      final response = await ApiClient.instance.post(
        '/rsvp/invite/$eventId',
        data: {'inviteeIds': inviteeIds},
      );
      final result = ApiResponse<List<InviteModel>>.fromJson(
        response.data,
        (data) => List<InviteModel>.from(
          (data as List).map((x) => InviteModel.fromJson(x)),
        ),
      );
      return result.data ?? [];
    } catch (e) {
      throw Exception('Failed to send invites: $e');
    }
  }

  Future<List<InviteModel>> getMyInvites() async {
    try {
      final response = await ApiClient.instance.get('/rsvp/invite/my');
      final result = ApiResponse<List<InviteModel>>.fromJson(
        response.data,
        (data) => List<InviteModel>.from(
          (data as List).map((x) => InviteModel.fromJson(x)),
        ),
      );
      return result.data ?? [];
    } catch (e) {
      throw Exception('Failed to load invites: $e');
    }
  }

  Future<InviteModel> respondToInvite(String inviteId, String action) async {
    try {
      final response = await ApiClient.instance.patch(
        '/rsvp/invite/$inviteId',
        data: {'action': action},
      );
      final result = ApiResponse<InviteModel>.fromJson(
        response.data,
        (data) => InviteModel.fromJson(data),
      );
      return result.data!;
    } catch (e) {
      throw Exception('Failed to respond to invite: $e');
    }
  }

  Future<List<RSVPUserModel>> searchUsers(String query) async {
    try {
      final response = await ApiClient.instance.get(
        '/users/search',
        queryParameters: {'q': query},
      );
      final result = ApiResponse<List<RSVPUserModel>>.fromJson(
        response.data,
        (data) => List<RSVPUserModel>.from(
          (data as List).map((x) => RSVPUserModel.fromJson(x)),
        ),
      );
      return result.data ?? [];
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  Future<NotificationPrefsModel> getNotificationPrefs() async {
    try {
      final response = await ApiClient.instance.get('/rsvp/notification-prefs');
      final result = ApiResponse<NotificationPrefsModel>.fromJson(
        response.data,
        (data) => NotificationPrefsModel.fromJson(data),
      );
      return result.data!;
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
      final result = ApiResponse<NotificationPrefsModel>.fromJson(
        response.data,
        (data) => NotificationPrefsModel.fromJson(data),
      );
      return result.data!;
    } catch (e) {
      throw Exception('Failed to update notification preferences: $e');
    }
  }
  Future<void> cancelRSVP(String eventId) async {
    try {
      await ApiClient.instance.delete('/rsvp/$eventId');
    } catch (e) {
      throw Exception('Failed to cancel RSVP: $e');
    }
  }
}
