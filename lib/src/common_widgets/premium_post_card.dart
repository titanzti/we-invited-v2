import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../constants/app_theme.dart';
import '../features/events/domain/post_model.dart';

/// Premium-styled post card widget reused across multiple screens
class PremiumPostCard extends StatelessWidget {
  final PostModel post;
  const PremiumPostCard({super.key, required this.post});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = date.difference(now);
    if (diff.isNegative) return 'Ended';
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Tomorrow';
    if (diff.inDays < 7) return DateFormat('EEEE').format(date);
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateLabel = _formatDate(post.startdateTime);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/feed/event', extra: post);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight, width: 1),
          boxShadow: isDark ? null : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(children: [
              Hero(
                tag: 'event_image_${post.postid}',
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: post.image.isNotEmpty
                      ? CachedNetworkImage(imageUrl: post.image, fit: BoxFit.cover, placeholder: (context, url) => Container(color: isDark ? AppTheme.darkSurface : AppTheme.borderLight), errorWidget: (context, url, error) => Container(color: isDark ? AppTheme.darkSurface : AppTheme.borderLight, child: const Icon(Icons.image_not_supported, color: Colors.grey)))
                      : Container(color: AppTheme.primaryBlue.withValues(alpha: 0.1), child: const Icon(Icons.event, size: 48, color: AppTheme.primaryBlue)),
                ),
              ),
              if (dateLabel.isNotEmpty)
                Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)), child: Text(dateLabel, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)))),
              if (post.requiresApproval)
                Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.circular(8)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.verified_user, size: 12, color: Colors.white), SizedBox(width: 4), Text('Approval', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))]))),
            ]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  if (post.category.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isDark ? AppTheme.primaryBlue.withValues(alpha: 0.2) : const Color(0xFFF2F9FF), borderRadius: BorderRadius.circular(9999)), child: Text(post.category, style: Theme.of(context).textTheme.labelSmall)),
                  Icon(Icons.favorite_border, color: isDark ? AppTheme.darkTextSecondary : AppTheme.primaryDark, size: 20),
                ]),
                const SizedBox(height: 10),
                Hero(tag: 'post_title_${post.postid}', child: Text(post.name.isNotEmpty ? post.name : 'Untitled Event', style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(post.place.isNotEmpty ? post.place : 'Location TBD', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  if (post.numpeople.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.people_outline, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(post.numpeople, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ],
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
