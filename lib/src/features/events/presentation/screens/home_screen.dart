import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../authentication/presentation/controllers/auth_controller.dart';
import '../controllers/feed_controller.dart';
import '../../../../constants/app_theme.dart';
import '../../domain/post_model.dart';
import '../../../../common_widgets/feed_skeleton_loader.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMetadata,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Outstanding Events',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          feedState.when(
            data: (posts) {
              if (posts.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No events happening right now.'),
                  ),
                );
              }
              
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100), // 100 bottom to pass the floating navbar
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = posts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: PremiumPostCard(post: post)
                            .animate()
                            .fade(delay: Duration(milliseconds: 100 * (index % 5)))
                            .slideY(begin: 0.1),
                      );
                    },
                    childCount: posts.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: FeedSkeletonLoader(),
            ),
            error: (err, st) => SliverFillRemaining(
              child: Center(child: Text('Error loading feed: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumPostCard extends StatelessWidget {
  final PostModel post;

  const PremiumPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/feed/event', extra: post);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),  // Notion default card radius
          border: Border.all(color: AppTheme.borderLight, width: 1), // Whisper border
          boxShadow: PremiumShadows.softCard,      // Ambient layered occlusion
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'event_image_${post.postid}',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: post.image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: post.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: AppTheme.borderLight),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.borderLight,
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        child: const Icon(Icons.event, size: 48, color: AppTheme.primaryBlue),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (post.category.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F9FF), // Notion Pill BG
                            borderRadius: BorderRadius.circular(9999), // Notion Pill
                          ),
                          child: Text(
                            post.category, // Standard case rather than ALL CAPS for Notion Badges
                            style: Theme.of(context).textTheme.labelSmall, // Inherits specific Notion badge styling
                          ),
                        ),
                      const Icon(Icons.favorite_border, color: AppTheme.primaryDark),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  Hero(
                    tag: 'post_title_${post.postid}',
                    child: Text(
                      post.name.isNotEmpty ? post.name : 'Untitled Event',
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.place.isNotEmpty ? post.place : 'Location TBD',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
