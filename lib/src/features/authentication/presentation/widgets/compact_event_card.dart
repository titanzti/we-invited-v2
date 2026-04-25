import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_theme.dart';
import '../../../events/domain/post_model.dart';

class CompactEventCard extends StatelessWidget {
  final PostModel post;

  const CompactEventCard({super.key, required this.post});

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
        height: 110,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : const Color(0xFF0F172A).withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            _buildImage(isDark),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMetaRow(isDark, dateLabel),
                    const SizedBox(height: 10),
                    Text(
                      post.name.isNotEmpty ? post.name : 'Untitled Event',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _buildLocationRow(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F5F9),
      ),
      child: post.image.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: post.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F5F9),
              ),
              errorWidget: (context, url, error) => Container(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F5F9),
                child: const Icon(Icons.image_not_supported, color: AppTheme.grey500),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF3B82F6),
                    Color(0xFF4F46E5),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(Icons.event_available_rounded, color: AppTheme.surfaceWhite, size: 36),
              ),
            ),
    );
  }

  Widget _buildMetaRow(bool isDark, String dateLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (post.category.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              post.category.toUpperCase(),
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF3B82F6),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          )
        else
          const SizedBox(),
        if (dateLabel.isNotEmpty)
          Text(
            dateLabel,
            style: TextStyle(
              color: isDark ? AppTheme.grey400 : const Color(0xFF64748B),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildLocationRow(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.location_on_rounded, size: 12, color: isDark ? AppTheme.grey500 : const Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            post.place.isNotEmpty ? post.place : 'Location TBD',
            style: TextStyle(
              color: isDark ? AppTheme.grey400 : const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
