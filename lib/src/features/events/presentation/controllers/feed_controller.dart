import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/post_model.dart';
import '../../data/post_repository.dart';

part 'feed_controller.g.dart';

@riverpod
class FeedController extends _$FeedController {
  @override
  Stream<List<PostModel>> build() {
    return ref.watch(postRepositoryProvider).getPostsStream();
  }

  Future<void> createPost(PostModel post) async {
    // Keep old state while doing the op
    final previousState = state;
    try {
      await ref.read(postRepositoryProvider).createPost(post);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      // Revert if error handling required
      // state = previousState;
      rethrow;
    }
  }
}
