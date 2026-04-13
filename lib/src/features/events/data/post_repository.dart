import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/api_client.dart';

import '../domain/post_model.dart';
import '../domain/join_event_model.dart';

part 'post_repository.g.dart';

@Riverpod(keepAlive: true)
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository();
}

class PostRepository {
  PostRepository();

  // Fetch Events from real backend API via Dio Future
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await ApiClient.instance.get('/events');
      final data = response.data['data'] as List;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load events from backend: $e');
    }
  }

  // Retrieve user specific joined events
  Stream<List<JoinEventModel>> getJoinedEventsStream(String uid) {
    return const Stream.empty();
  }

  // Create a new post
  Future<void> createPost(String title, String location, String category, {String? imageUrl}) async {
    try {
      await ApiClient.instance.post('/events', data: {
        'title': title,
        'location': location,
        'category': category,
        if (imageUrl != null && imageUrl.isNotEmpty) 'imageUrl': imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  // Update a post
  Future<void> updatePost(PostModel post) async {}

  // Request to join an event
  Future<void> requestToJoin(JoinEventModel joinRequest) async {}
}
