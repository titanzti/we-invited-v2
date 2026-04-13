import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/post_model.dart';
import '../../../../constants/app_theme.dart';
import '../../../../common_widgets/global_premium_widgets.dart';

class EventDetailScreen extends ConsumerWidget {
  final PostModel post;

  const EventDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Generate an Unsplash Image if empty
    final imageUrl = post.image.isNotEmpty
        ? post.image
        : 'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?q=80&w=800&auto=format&fit=crop';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 350.0,
                stretch: true,
                pinned: true,
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: BackButton(
                      color: AppTheme.textBody,
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Hero(
                    tag: 'event_image_${post.postid}',
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          post.category.isNotEmpty ? post.category : 'Party',
                          style: TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ).animate().fade().slideY(begin: 0.2),
                      
                      const SizedBox(height: 16),
                      
                      // Title
                      Text(
                        post.name.isNotEmpty ? post.name : 'Exclusive Event',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                      ).animate().fade(delay: 100.ms).slideY(begin: 0.2),
                      
                      const SizedBox(height: 12),
                      
                      // Host Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppTheme.primaryBlue.withOpacity(0.2),
                            backgroundImage: post.postbyimage.isNotEmpty 
                                ? NetworkImage(post.postbyimage) 
                                : null,
                            child: post.postbyimage.isEmpty 
                                ? const Icon(Icons.person, color: AppTheme.primaryBlue, size: 20) 
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Hosted by ${post.postbyname.isNotEmpty ? post.postbyname : 'Anonymous'}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ).animate().fade(delay: 200.ms).slideX(begin: -0.1),
                      
                      const SizedBox(height: 24),
                      
                      // Info Grid
                      Row(
                        children: [
                          _buildInfoTile(context, Icons.location_on_outlined, post.place.isNotEmpty ? post.place : 'Secret Location'),
                          const SizedBox(width: 16),
                          _buildInfoTile(context, Icons.people_outline, '${post.numpeople.isNotEmpty ? post.numpeople : "50"} People'),
                        ],
                      ).animate().fade(delay: 300.ms).slideY(begin: 0.1),
                      
                      const SizedBox(height: 32),
                      
                      // Description
                      Text(
                        'About Event',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ).animate().fade(delay: 400.ms),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        post.description.isNotEmpty 
                            ? post.description 
                            : 'Join us for an unforgettable experience. Come ready to meet amazing people and enjoy the vibe of the city. RSVP quickly as spots are limited!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                      ).animate().fade(delay: 500.ms),
                      
                      const SizedBox(height: 120), // Bottom padding for sticky button
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Sticky Bottom Join Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: AnimatedPrimaryButton(
                text: 'Join Event',
                onPressed: () {
                  // TODO: Wire up Join Event API Call
                },
              ),
            ).animate().slideY(begin: 1.0, duration: 600.ms, delay: 600.ms, curve: Curves.easeOutQuart),
          )
        ],
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.primaryBlue, size: 24),
            const SizedBox(height: 8),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
