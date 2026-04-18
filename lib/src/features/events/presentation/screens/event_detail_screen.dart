import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/post_model.dart';
import '../../domain/rsvp_model.dart';
import '../../data/post_repository.dart';
import '../../presentation/controllers/rsvp_controller.dart';
import '../../presentation/controllers/feed_controller.dart';
import '../../presentation/widgets/rsvp_status_card.dart';
import '../../../authentication/data/auth_repository.dart';
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
  RSVPStatus? _myRSVPStatus;
  int _guestCount = 0;
  RSVPStats? _rsvpStats;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadRSVPStats(),
      _loadMyRSVP(),
    ]);
  }

  Future<void> _loadMyRSVP() async {
    try {
      final myRsvp = await ref.read(rsvpControllerProvider.notifier).getMyRSVP(widget.post.postid);
      if (mounted && myRsvp != null) {
        setState(() {
          _myRSVPStatus = myRsvp.status;
          _guestCount = myRsvp.guestCount;
          _hasJoined = true;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadRSVPStats() async {
    try {
      final stats = await ref.read(rsvpControllerProvider.notifier).getEventRSVPStats(widget.post.postid);
      if (mounted) {
        setState(() => _rsvpStats = stats);
      }
    } catch (e) {
      // Silently ignore stats load failure
    }
  }

  Future<void> _submitRSVP(RSVPStatus status) async {
    HapticFeedback.mediumImpact();
    
    if (status == RSVPStatus.going) {
      final guestCount = await showDialog<int>(
        context: context,
        builder: (context) => _GuestCountDialog(currentCount: _guestCount),
      );
      if (guestCount == null) return;
      _guestCount = guestCount;
    }

    setState(() => _isJoining = true);
    try {
      if (status == RSVPStatus.going || status == RSVPStatus.maybe) {
        try {
          final joinResp = await ref.read(postRepositoryProvider).joinEvent(widget.post.postid);
          if (joinResp.status == 'PENDING') {
            if (mounted) {
              setState(() {
                _isJoining = false;
                _hasJoined = true;
                _isPendingApproval = true;
              });
              PremiumToast.show(context, '📩 Request sent! Waiting for approval.');
            }
            return;
          }
        } catch (_) {
          // Ignore join failure (likely already joined)
        }
      }

      await ref.read(rsvpControllerProvider.notifier).submitRSVP(
        eventId: widget.post.postid,
        status: status,
        guestCount: status == RSVPStatus.going ? _guestCount : 0,
      );

      if (mounted) {
        HapticFeedback.heavyImpact();
        setState(() {
          _myRSVPStatus = status;
          _hasJoined = true; // Mark as joined locally
          _isJoining = false;
        });

        final messages = {
          RSVPStatus.going: '🎉 You\'re going! +$_guestCount guests',
          RSVPStatus.maybe: '🤔 Maybe - we\'ll keep you posted',
          RSVPStatus.notGoing: '😔 Not going - maybe next time',
        };
        PremiumToast.show(context, messages[status]!);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isJoining = false);
        PremiumToast.show(context, 'Failed to RSVP. Try again.', isError: true);
      }
    }
  }

  String _formatEventDate(DateTime? date) {
    if (date == null) return 'TBD';
    return DateFormat('EEEE, MMMM d · h:mm a').format(date);
  }

  Future<void> _deleteEvent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      HapticFeedback.heavyImpact();
      try {
        await ref.read(postRepositoryProvider).deleteEvent(widget.post.postid);
        ref.invalidate(feedControllerProvider);
        if (mounted) {
          PremiumToast.show(context, '🗑️ Event deleted');
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          PremiumToast.show(context, 'Failed to delete event', isError: true);
        }
      }
    }
  }

  Future<void> _cancelRSVP() async {
    HapticFeedback.mediumImpact();
    setState(() => _isJoining = true);
    try {
      await ref.read(rsvpControllerProvider.notifier).cancelRSVP(widget.post.postid);
      if (mounted) {
        setState(() {
          _myRSVPStatus = null;
          _hasJoined = false;
          _isJoining = false;
        });
        PremiumToast.show(context, 'RSVP cancelled');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isJoining = false);
        PremiumToast.show(context, 'Failed to cancel RSVP', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authUser = ref.watch(authStateProvider).value;
    final isHost = authUser != null && authUser.uid == widget.post.uid;
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
                  // Invite
                  Builder(builder: (context) {
                    if (!isHost) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.push('/feed/event/invite', extra: widget.post);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_add, color: Colors.white, size: 18),
                        ),
                      ),
                    );
                  }),
                  // Edit
                  Builder(builder: (context) {
                    if (!isHost) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.push('/feed/event/edit', extra: widget.post);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    );
                  }),
                  // Delete
                  Builder(builder: (context) {
                    if (!isHost) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _deleteEvent();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        final event = widget.post;
                        final dateStr = event.startdateTime != null
                            ? DateFormat('MMM d, y · h:mm a').format(event.startdateTime!)
                            : 'Date TBD';
                        final text = '🎉 ${event.name}\n'
                            '📍 ${event.place}\n'
                            '📅 $dateStr\n\n'
                            'Join me on We Invited!';
                        Share.share(text);
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

                      const SizedBox(height: 28),

                      // RSVP Section is moved to sticky footer


                      if (_hasJoined && _isPendingApproval)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.hourglass_top, color: Colors.orange),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Waiting for host approval. You\'ll be able to RSVP once approved.',
                                  style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fade(delay: 600.ms).slideY(begin: 0.1),

                      if (_rsvpStats != null)
                        RSVPStatusCard(
                          stats: _rsvpStats!,
                          onViewGuests: () => context.push('/feed/event/guests', extra: widget.post),
                        ).animate().fade(delay: _hasJoined ? 750.ms : 600.ms).slideY(begin: 0.1),

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
              child: isHost
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.stars, color: AppTheme.primaryBlue),
                          SizedBox(width: 8),
                          Text(
                            'Your Event',
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _isPendingApproval
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.hourglass_top, color: Colors.orange),
                              SizedBox(width: 8),
                              Text(
                                'Request Sent',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ).animate().scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack)
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Are you going?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.darkTextSecondary : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _RSVPActionButtons(
                              currentStatus: _myRSVPStatus,
                              isJoining: _isJoining,
                              onGoing: () => _submitRSVP(RSVPStatus.going),
                              onMaybe: () => _submitRSVP(RSVPStatus.maybe),
                              onNotGoing: () => _submitRSVP(RSVPStatus.notGoing),
                            ),
                            if (_myRSVPStatus != null) ...[
                              const SizedBox(height: 8),
                              Center(
                                child: TextButton.icon(
                                  onPressed: _isJoining ? null : _cancelRSVP,
                                  icon: const Icon(Icons.cancel_outlined, size: 16),
                                  label: const Text('Cancel RSVP'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey.shade500,
                                    textStyle: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ],
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

class _RSVPActionButtons extends StatelessWidget {
  final RSVPStatus? currentStatus;
  final bool isJoining;
  final VoidCallback onGoing;
  final VoidCallback onMaybe;
  final VoidCallback onNotGoing;

  const _RSVPActionButtons({
    required this.currentStatus,
    required this.isJoining,
    required this.onGoing,
    required this.onMaybe,
    required this.onNotGoing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RSVPButton(
            icon: Icons.check_circle,
            label: 'Going',
            color: Colors.green,
            isSelected: currentStatus == RSVPStatus.going,
            isLoading: isJoining,
            onTap: currentStatus == RSVPStatus.going ? null : onGoing,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RSVPButton(
            icon: Icons.help_outline,
            label: 'Maybe',
            color: Colors.orange,
            isSelected: currentStatus == RSVPStatus.maybe,
            isLoading: isJoining,
            onTap: currentStatus == RSVPStatus.maybe ? null : onMaybe,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RSVPButton(
            icon: Icons.cancel,
            label: 'Not Going',
            color: Colors.red,
            isSelected: currentStatus == RSVPStatus.notGoing,
            isLoading: isJoining,
            onTap: currentStatus == RSVPStatus.notGoing ? null : onNotGoing,
          ),
        ),
      ],
    );
  }
}

class _RSVPButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback? onTap;

  const _RSVPButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? color.withValues(alpha: 0.1) : (isDark ? AppTheme.darkSurface : Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(
            color: isSelected ? color : (isDark ? AppTheme.darkBorder : Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : (isDark ? AppTheme.darkTextPrimary : Colors.grey.shade700),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : (isDark ? AppTheme.darkTextPrimary : Colors.grey.shade700),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestCountDialog extends StatefulWidget {
  final int currentCount;

  const _GuestCountDialog({required this.currentCount});

  @override
  State<_GuestCountDialog> createState() => _GuestCountDialogState();
}

class _GuestCountDialogState extends State<_GuestCountDialog> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.currentCount;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('How many guests?'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _count > 0 ? () => setState(() => _count--) : null,
            icon: const Icon(Icons.remove_circle_outline),
            iconSize: 32,
          ),
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$_count',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: _count < 10 ? () => setState(() => _count++) : null,
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 32,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, _count),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}