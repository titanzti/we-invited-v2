import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../domain/post_model.dart';
import '../../data/post_repository.dart';
import '../../../../constants/app_theme.dart';
import '../../../../common_widgets/global_premium_widgets.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final PostModel post;

  const EventDetailScreen({super.key, required this.post});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  bool _isJoining = false;
  bool _hasJoined = false;
  bool _isPendingApproval = false;

  String _formatEventDate(DateTime? date) {
    if (date == null) return 'TBD';
    return DateFormat('EEEE, MMMM d · h:mm a').format(date);
  }

  Future<void> _showJoinSheet() async {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              Icons.celebration,
              size: 48,
              color: AppTheme.primaryBlue,
            ),
            const SizedBox(height: 16),
            Text(
              widget.post.requiresApproval ? 'Request to Join?' : 'Join this Event?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.post.name.isNotEmpty ? widget.post.name : 'Exclusive Event',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.post.startdateTime != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppTheme.primaryBlue),
                    const SizedBox(width: 6),
                    Text(
                      _formatEventDate(widget.post.startdateTime),
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: AnimatedPrimaryButton(
                    text: widget.post.requiresApproval ? 'Send Request' : 'Confirm Join',
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isJoining = true);
      try {
        final response = await ref.read(postRepositoryProvider).joinEvent(widget.post.postid);
        if (mounted) {
          HapticFeedback.heavyImpact();
          final isPending = response.status == 'PENDING';
          setState(() {
            _isJoining = false;
            _hasJoined = true;
            _isPendingApproval = isPending;
          });
          PremiumToast.show(
            context,
            isPending ? '📩 Request sent! Waiting for approval.' : '🎉 You\'re in! See you there.',
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isJoining = false);
          PremiumToast.show(context, 'Failed to join. Try again.', isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrl = widget.post.image.isNotEmpty
        ? widget.post.image
        : 'https://images.unsplash.com/photo-1544928147-79a2dbc1f389?q=80&w=800&auto=format&fit=crop';

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 350.0,
                stretch: true,
                pinned: true,
                backgroundColor: isDark ? AppTheme.darkBackground : Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        // Share action
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.share, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Hero(
                    tag: 'event_image_${widget.post.postid}',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category + Date row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(alpha: isDark ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.post.category.isNotEmpty ? widget.post.category : 'Party',
                              style: const TextStyle(
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (widget.post.startdateTime != null)
                            Text(
                              DateFormat('MMM d').format(widget.post.startdateTime!),
                              style: TextStyle(
                                color: AppTheme.primaryBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ).animate().fade().slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        widget.post.name.isNotEmpty ? widget.post.name : 'Exclusive Event',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                      ).animate().fade(delay: 100.ms).slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      // Host info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                            backgroundImage: widget.post.postbyimage.isNotEmpty
                                ? NetworkImage(widget.post.postbyimage)
                                : null,
                            child: widget.post.postbyimage.isEmpty
                                ? const Icon(Icons.person, color: AppTheme.primaryBlue, size: 20)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.postbyname.isNotEmpty ? widget.post.postbyname : 'Anonymous',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Event Organizer',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ).animate().fade(delay: 200.ms).slideX(begin: -0.05),

                      const SizedBox(height: 24),

                      // Info grid
                      Row(
                        children: [
                          _buildInfoTile(
                            context,
                            Icons.location_on_outlined,
                            'Location',
                            widget.post.place.isNotEmpty ? widget.post.place : 'TBD',
                            isDark,
                          ),
                          const SizedBox(width: 12),
                          _buildInfoTile(
                            context,
                            Icons.people_outline,
                            'Capacity',
                            '${widget.post.numpeople.isNotEmpty ? widget.post.numpeople : "∞"} people',
                            isDark,
                          ),
                        ],
                      ).animate().fade(delay: 300.ms).slideY(begin: 0.1),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          _buildInfoTile(
                            context,
                            Icons.schedule,
                            'Starts',
                            _formatEventDate(widget.post.startdateTime),
                            isDark,
                          ),
                          const SizedBox(width: 12),
                          _buildInfoTile(
                            context,
                            Icons.event_available,
                            'Ends',
                            _formatEventDate(widget.post.entdateTime),
                            isDark,
                          ),
                        ],
                      ).animate().fade(delay: 350.ms).slideY(begin: 0.1),

                      const SizedBox(height: 28),

                      // Description
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ).animate().fade(delay: 400.ms),

                      const SizedBox(height: 12),

                      Text(
                        widget.post.description.isNotEmpty
                            ? widget.post.description
                            : 'Join us for an unforgettable experience. Meet amazing people and enjoy the vibe. RSVP quickly — spots are limited!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark ? AppTheme.darkTextSecondary : Colors.grey[600],
                          height: 1.7,
                        ),
                      ).animate().fade(delay: 500.ms),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky bottom Join button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 40),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBackground : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: _hasJoined
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: (_isPendingApproval ? Colors.orange : AppTheme.secondaryTeal).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: (_isPendingApproval ? Colors.orange : AppTheme.secondaryTeal).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isPendingApproval ? Icons.hourglass_top : Icons.check_circle,
                            color: _isPendingApproval ? Colors.orange : AppTheme.secondaryTeal,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isPendingApproval ? 'Request Sent' : 'You\'re Going!',
                            style: TextStyle(
                              color: _isPendingApproval ? Colors.orange : AppTheme.secondaryTeal,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ).animate().scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack)
                  : AnimatedPrimaryButton(
                      text: _isJoining ? 'Joining...' : (widget.post.requiresApproval ? 'Request to Join' : 'Join Event'),
                      onPressed: _isJoining ? null : _showJoinSheet,
                      isLoading: _isJoining,
                    ),
            ).animate().slideY(begin: 1.0, duration: 600.ms, delay: 600.ms, curve: Curves.easeOutQuart),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppTheme.darkBorder : Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryBlue, size: 16),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
