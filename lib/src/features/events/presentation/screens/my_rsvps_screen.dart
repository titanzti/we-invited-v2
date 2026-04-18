import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_theme.dart';
import '../../domain/rsvp_model.dart';
import '../../data/post_repository.dart';
import '../../presentation/controllers/rsvp_controller.dart';

class MyRSVPsScreen extends ConsumerStatefulWidget {
  const MyRSVPsScreen({super.key});

  @override
  ConsumerState<MyRSVPsScreen> createState() => _MyRSVPsScreenState();
}

class _MyRSVPsScreenState extends ConsumerState<MyRSVPsScreen> {
  List<RSVPModel> _rsvps = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final rsvps = await ref.read(rsvpControllerProvider.notifier).getMyRSVPs();
      if (mounted) {
        setState(() {
          _rsvps = rsvps;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load RSVPs';
          _isLoading = false;
        });
      }
    }
  }

  Color _statusColor(RSVPStatus status) {
    return switch (status) {
      RSVPStatus.going => Colors.green,
      RSVPStatus.maybe => Colors.orange,
      RSVPStatus.notGoing => Colors.red,
    };
  }

  String _statusLabel(RSVPStatus status) {
    return switch (status) {
      RSVPStatus.going => 'Going',
      RSVPStatus.maybe => 'Maybe',
      RSVPStatus.notGoing => 'Not Going',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_rsvps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No RSVPs yet',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Events you RSVP to will appear here',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 120),
      itemCount: _rsvps.length,
      itemBuilder: (context, index) {
        final rsvp = _rsvps[index];
        final event = rsvp.event;
        final color = _statusColor(rsvp.status);
        final dateText = event?.startDate != null
            ? DateFormat('MMM d · h:mm a').format(event!.startDate!)
            : 'Date TBD';

        return GestureDetector(
          onTap: () => _showRSVPDetail(rsvp),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDark ? null : PremiumShadows.softCard,
              border: isDark ? Border.all(color: AppTheme.darkBorder) : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.event, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event?.title.isNotEmpty == true ? event!.title : 'Untitled Event',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateText,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _statusLabel(rsvp.status),
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (rsvp.guestCount > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '+${rsvp.guestCount} guest${rsvp.guestCount != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppTheme.darkTextSecondary : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ).animate().fade(delay: Duration(milliseconds: 60 * index)).slideY(begin: 0.05);
      },
      ),
    );
  }

  void _showRSVPDetail(RSVPModel rsvp) {
    HapticFeedback.selectionClick();
    final color = _statusColor(rsvp.status);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
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
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.event, color: color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              rsvp.event?.title ?? 'Event',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _statusLabel(rsvp.status),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            if (rsvp.guestCount > 0) ...[
              const SizedBox(height: 8),
              Text(
                '+${rsvp.guestCount} guest${rsvp.guestCount != 1 ? 's' : ''}',
                style: TextStyle(
                  color: isDark ? AppTheme.darkTextSecondary : Colors.grey.shade600,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                if (rsvp.eventId.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('View Event'),
                      onPressed: () async {
                        Navigator.pop(sheetContext);
                        final router = GoRouter.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        try {
                          final post = await ref.read(postRepositoryProvider).getEventById(rsvp.eventId);
                          router.push('/feed/event', extra: post);
                        } catch (_) {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Could not load event')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
