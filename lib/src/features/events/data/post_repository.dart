import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/api_client.dart';
import '../domain/post_model.dart';
import '../domain/join_request_model.dart';
import 'join_event_response_dto.dart';

part 'post_repository.g.dart';

@Riverpod(keepAlive: true)
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository();
}

class PostRepository {
  PostRepository();

  Future<List<PostModel>> getPosts({String? category}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      final response = await ApiClient.instance.get(
        '/events',
        queryParameters: queryParams,
      );
      final data = response.data['data'] as List;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  Future<List<PostModel>> searchEvents(String query) async {
    try {
      final response = await ApiClient.instance.get(
        '/events',
        queryParameters: {'q': query},
      );
      final data = response.data['data'] as List;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search events: $e');
    }
  }

  Future<void> createPost({
    required String title,
    required String location,
    required String category,
    String? description,
    String? imageUrl,
    DateTime? startDateTime,
    DateTime? endDateTime,
    int? maxCapacity,
    bool requiresApproval = false,
    double? latitude,
    double? longitude,
  }) async {
    try {
      await ApiClient.instance.post('/events', data: {
        'title': title,
        'location': location,
        'category': category,
        if (description != null && description.isNotEmpty) 'description': description,
        if (imageUrl != null && imageUrl.isNotEmpty) 'imageUrl': imageUrl,
        if (startDateTime != null) 'startdateTime': startDateTime.toIso8601String(),
        if (endDateTime != null) 'endDateTime': endDateTime.toIso8601String(),
        if (maxCapacity != null) 'numpeople': maxCapacity.toString(),
        'requiresApproval': requiresApproval,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  Future<JoinEventResponseDto> joinEvent(String eventId) async {
    try {
      final response = await ApiClient.instance.post('/events/$eventId/join');
      return JoinEventResponseDto.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to join event: $e');
    }
  }

  Future<List<PostModel>> getMyEvents() async {
    try {
      final response = await ApiClient.instance.get('/events/me');
      final data = response.data['data'] as List;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load your events: $e');
    }
  }

  Future<List<JoinRequestModel>> getJoinRequests(String eventId) async {
    try {
      final response = await ApiClient.instance.get('/events/$eventId/requests');
      final data = response.data['data'] as List;
      return data.map((json) => JoinRequestModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }

  Future<void> respondToJoinRequest(String eventId, String joinId, String action) async {
    try {
      await ApiClient.instance.patch(
        '/events/$eventId/requests/$joinId',
        data: {'action': action},
      );
    } catch (e) {
      throw Exception('Failed to $action request: $e');
    }
  }
}
