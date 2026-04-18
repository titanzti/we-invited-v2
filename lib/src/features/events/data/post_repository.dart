import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/api_client.dart';
import '../../../utils/api_response.dart';
import '../domain/post_model.dart';
import '../domain/join_request_model.dart';
import 'join_event_response_dto.dart';

part 'post_repository.g.dart';

class FeedPage {
  final List<PostModel> posts;
  final String? nextCursor;
  final bool hasMore;

  const FeedPage({required this.posts, this.nextCursor, this.hasMore = false});
}

@Riverpod(keepAlive: true)
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository();
}

class PostRepository {
  PostRepository();

  Future<FeedPage> getPosts({String? category, String? cursor, int limit = 15}) async {
    try {
      final response = await ApiClient.instance.get(
        '/events',
        queryParameters: {
          if (category != null && category.isNotEmpty) 'category': category,
          if (cursor != null) 'cursor': cursor,
          'limit': limit.toString(),
        },
      );
      final raw = response.data as Map<String, dynamic>;
      final posts = (raw['data'] as List? ?? [])
          .map((x) => PostModel.fromJson(x))
          .toList();
      return FeedPage(
        posts: posts,
        nextCursor: raw['nextCursor'] as String?,
        hasMore: raw['hasMore'] as bool? ?? false,
      );
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
      final result = ApiResponse<List<PostModel>>.fromJson(
        response.data,
        (data) => List<PostModel>.from(
          (data as List).map((x) => PostModel.fromJson(x)),
        ),
      );
      return result.data ?? [];
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
        if (endDateTime != null) 'entdateTime': endDateTime.toIso8601String(),
        if (maxCapacity != null) 'numpeople': maxCapacity.toString(),
        'requiresApproval': requiresApproval,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  Future<String?> uploadEventImage(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType('image', 'png'),
        ),
      });
      final response = await ApiClient.instance.post('/events/upload-image', data: formData);
      final result = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      return result.data?['url'] as String?;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> updateEvent({
    required String eventId,
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
      await ApiClient.instance.patch('/events/$eventId', data: {
        'title': title,
        'location': location,
        'category': category,
        if (description != null && description.isNotEmpty) 'description': description,
        if (imageUrl != null && imageUrl.isNotEmpty) 'imageUrl': imageUrl,
        if (startDateTime != null) 'startdateTime': startDateTime.toIso8601String(),
        if (endDateTime != null) 'entdateTime': endDateTime.toIso8601String(),
        if (maxCapacity != null) 'numpeople': maxCapacity.toString(),
        'requiresApproval': requiresApproval,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      });
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await ApiClient.instance.delete('/events/$eventId');
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<JoinEventResponseDto> joinEvent(String eventId) async {
    try {
      debugPrint('[joinEvent] POST /events/$eventId/join');
      final response = await ApiClient.instance.post('/events/$eventId/join');
      debugPrint('[joinEvent] statusCode: ${response.statusCode}');
      final result = ApiResponse<JoinEventResponseDto>.fromJson(
        response.data,
        (data) => JoinEventResponseDto.fromJson(data),
      );
      return result.data!;
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final serverMsg = responseData is Map ? (responseData['error'] as String?) ?? '' : '';
      debugPrint('[joinEvent] DioException ${e.response?.statusCode}: $serverMsg');

      if (e.response?.statusCode == 409 && serverMsg.contains('Already')) {
        return const JoinEventResponseDto(status: 'APPROVED', message: 'You already joined this event');
      }

      throw Exception(serverMsg.isNotEmpty ? serverMsg : 'Failed to join event');
    } catch (e) {
      debugPrint('[joinEvent] ERROR: $e');
      throw Exception('Failed to join event: $e');
    }
  }

  Future<List<PostModel>> getMyEvents() async {
    try {
      final response = await ApiClient.instance.get('/events/me');
      final result = ApiResponse<List<PostModel>>.fromJson(
        response.data,
        (data) => List<PostModel>.from(
          (data as List).map((x) => PostModel.fromJson(x)),
        ),
      );
      return result.data ?? [];
    } catch (e) {
      throw Exception('Failed to load your events: $e');
    }
  }

  Future<List<JoinRequestModel>> getJoinRequests(String eventId) async {
    try {
      final response = await ApiClient.instance.get('/events/$eventId/requests');
      final result = ApiResponse<List<JoinRequestModel>>.fromJson(
        response.data,
        (data) => List<JoinRequestModel>.from(
          (data as List).map((x) => JoinRequestModel.fromJson(x)),
        ),
      );
      return result.data ?? [];
    } catch (e) {
      throw Exception('Failed to load requests: $e');
    }
  }

  Future<PostModel> getEventById(String eventId) async {
    try {
      final response = await ApiClient.instance.get('/events/$eventId');
      final result = ApiResponse<PostModel>.fromJson(
        response.data,
        (data) => PostModel.fromJson(data),
      );
      return result.data!;
    } catch (e) {
      throw Exception('Failed to load event: $e');
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
