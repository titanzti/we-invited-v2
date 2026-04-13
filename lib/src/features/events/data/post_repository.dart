import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/post_model.dart';
import '../domain/join_event_model.dart';

part 'post_repository.g.dart';

@Riverpod(keepAlive: true)
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository();
}

class PostRepository {
  PostRepository();

  // Retrieve bounded generic Posts (Max 30) to prevent OOM / quota bleeding
  Stream<List<PostModel>> getPostsStream() {
    // Returning Mock Data since Firebase is not initialized
    return Stream.value([
      PostModel(
        postid: '1',
        uid: 'user1',
        name: 'Tech Meetup 2026',
        place: 'Bangkok, Thailand',
        category: 'Technology',
        image: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
      ),
      PostModel(
        postid: '2',
        uid: 'user2',
        name: 'Music Festival',
        place: 'Chiang Mai',
        category: 'Entertainment',
        image: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=80',
      ),
      PostModel(
        postid: '3',
        uid: 'user3',
        name: 'Startup Pitch Deck',
        place: 'Phuket, Thailand',
        category: 'Business',
        image: 'https://images.unsplash.com/photo-1556761175-4b46a572b786?w=800&q=80',
      ),
    ]);
  }

  // Retrieve user specific joined events
  Stream<List<JoinEventModel>> getJoinedEventsStream(String uid) {
    return const Stream.empty();
  }

  // Create a new post
  Future<void> createPost(PostModel post) async {}

  // Update a post
  Future<void> updatePost(PostModel post) async {}

  // Request to join an event
  Future<void> requestToJoin(JoinEventModel joinRequest) async {}
}
