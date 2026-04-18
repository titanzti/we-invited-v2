import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/post_model.dart';
import '../../data/post_repository.dart';

part 'feed_controller.g.dart';

class FeedState {
  final List<PostModel> posts;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;

  const FeedState({
    this.posts = const [],
    this.nextCursor,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  FeedState copyWith({
    List<PostModel>? posts,
    String? nextCursor,
    bool? hasMore,
    bool? isLoadingMore,
    bool clearCursor = false,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

@riverpod
class FeedController extends _$FeedController {
  @override
  Future<FeedState> build() async {
    final page = await ref.watch(postRepositoryProvider).getPosts();
    return FeedState(
      posts: page.posts,
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(postRepositoryProvider)
          .getPosts(cursor: current.nextCursor);
      final updated = current.copyWith(
        posts: [...current.posts, ...page.posts],
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
        isLoadingMore: false,
      );
      state = AsyncData(updated);
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}
