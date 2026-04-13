import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/post_model.dart';
import '../../data/post_repository.dart';

part 'feed_controller.g.dart';

@riverpod
class FeedController extends _$FeedController {
  @override
  Future<List<PostModel>> build() async {
    return ref.watch(postRepositoryProvider).getPosts();
  }
}
