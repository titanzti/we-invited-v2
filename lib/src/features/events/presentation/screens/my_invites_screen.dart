import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_theme.dart';
import '../../../../common_widgets/global_premium_widgets.dart';
import '../../domain/invite_model.dart';
import '../../presentation/controllers/rsvp_controller.dart';

class MyInvitesScreen extends ConsumerStatefulWidget {
  const MyInvitesScreen({super.key});

  @override
  ConsumerState<MyInvitesScreen> createState() => _MyInvitesScreenState();
}

class _MyInvitesScreenState extends ConsumerState<MyInvitesScreen> {
  List<InviteModel> _invites = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInvites();
  }

  Future<void> _loadInvites() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }
    try {
      final invites = await ref.read(rsvpControllerProvider.notifier).getMyInvites();
      if (mounted) {
        setState(() {
          _invites = invites;
          _error = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load invites';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _respond(InviteModel invite, String action) async {
    HapticFeedback.heavyImpact();
    try {
      await ref.read(rsvpControllerProvider.notifier).respondToInvite(invite.id, action);
      if (mounted) {
        setState(() => _invites.removeWhere((i) => i.id == invite.id));
        PremiumToast.show(context, action == 'accept' ? '✅ Invite accepted!' : '❌ Invite declined');
      }
    } catch (e) {
      if (mounted) {
        PremiumToast.show(context, 'Failed to respond', isError: true);
      }
    }
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
            Icon(Icons.error_outline, size: 48, color: AppTheme.grey400),
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: AppTheme.grey600)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _loadInvites, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_invites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, size: 64, color: AppTheme.grey300),
            const SizedBox(height: 16),
            Text(
              'No invites yet',
              style: TextStyle(color: AppTheme.grey500, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'When someone invites you to an event,\nit will appear here',
              style: TextStyle(color: AppTheme.grey400, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInvites,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 120),
        itemCount: _invites.length,
        itemBuilder: (context, index) {
          final invite = _invites[index];
          final eventTitle = invite.event?.title ?? 'Untitled Event';
          final inviterName = invite.inviter?.name ?? 'Someone';
          final dateText = invite.event?.startDate != null
              ? DateFormat('MMM d · h:mm a').format(invite.event!.startDate!)
              : 'Date TBD';
          final isPending = invite.status == 'PENDING';

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDark ? null : PremiumShadows.softCard,
              border: isDark ? Border.all(color: AppTheme.darkBorder) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.mail, color: AppTheme.primaryBlue, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventTitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'From $inviterName · $dateText',
                            style: AppTheme.caption(isDark),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isPending) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _respond(invite, 'decline'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: AppTheme.grey300),
                          ),
                          child: const Text('Decline', style: TextStyle(fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _respond(invite, 'accept'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('Accept', style: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: invite.status == 'ACCEPTED'
                          ? AppTheme.semanticGreen.withValues(alpha: 0.1)
                          : AppTheme.semanticRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      invite.status == 'ACCEPTED' ? 'Accepted' : 'Declined',
                      style: TextStyle(
                        color: invite.status == 'ACCEPTED' ? AppTheme.semanticGreen : AppTheme.semanticRed,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ).animate().fade(delay: Duration(milliseconds: 60 * index)).slideY(begin: 0.05);
        },
      ),
    );
  }
}
