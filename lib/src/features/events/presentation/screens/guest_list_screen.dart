import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_theme.dart';
import '../../domain/rsvp_model.dart';
import '../../presentation/controllers/rsvp_controller.dart';

class GuestListScreen extends ConsumerStatefulWidget {
  final String eventId;
  final String eventTitle;

  const GuestListScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  ConsumerState<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends ConsumerState<GuestListScreen> {
  List<RSVPModel> _rsvps = [];
  RSVPStats? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        ref.read(rsvpControllerProvider.notifier).getEventRSVPs(widget.eventId),
        ref.read(rsvpControllerProvider.notifier).getEventRSVPStats(widget.eventId),
      ]);
      if (mounted) {
        setState(() {
          _rsvps = results[0] as List<RSVPModel>;
          _stats = results[1] as RSVPStats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load guests';
          _isLoading = false;
        });
      }
    }
  }

  List<RSVPModel> _rsvpsForStatus(RSVPStatus status) {
    return _rsvps.where((r) => r.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.surfaceWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.surfaceWhite,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurface : AppTheme.grey100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.primaryDark,
                    size: 18,
                  ),
                ),
              ),
            ),
            title: Text(
              'Guest List',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.primaryDark,
              ),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppTheme.grey400),
                    const SizedBox(height: 12),
                    Text(_error!, style: TextStyle(color: AppTheme.grey600)),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: _loadData, child: const Text('Retry')),
                  ],
                ),
              ),
            )
          else ...[
            // Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  children: [
                    _buildStatBox('Going', _stats?.going ?? 0, AppTheme.semanticGreen),
                    const SizedBox(width: 12),
                    _buildStatBox('Maybe', _stats?.maybe ?? 0, AppTheme.semanticOrange),
                    const SizedBox(width: 12),
                    _buildStatBox('Not Going', _stats?.notGoing ?? 0, AppTheme.semanticRed),
                  ],
                ).animate().fade().slideY(begin: 0.1),
              ),
            ),
            // Going
            _buildGroupHeader('Going', AppTheme.semanticGreen, _rsvpsForStatus(RSVPStatus.going).length),
            _buildGuestList(_rsvpsForStatus(RSVPStatus.going), AppTheme.semanticGreen, isDark),
            // Maybe
            _buildGroupHeader('Maybe', AppTheme.semanticOrange, _rsvpsForStatus(RSVPStatus.maybe).length),
            _buildGuestList(_rsvpsForStatus(RSVPStatus.maybe), AppTheme.semanticOrange, isDark),
            // Not Going
            _buildGroupHeader('Not Going', AppTheme.semanticRed, _rsvpsForStatus(RSVPStatus.notGoing).length),
            _buildGuestList(_rsvpsForStatus(RSVPStatus.notGoing), AppTheme.semanticRed, isDark),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, int count, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.grey200,
          ),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String title, Color color, int count) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.primaryDark,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestList(List<RSVPModel> list, Color color, bool isDark) {
    if (list.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text(
            'No one yet',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey500,
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final rsvp = list[index];
          final user = rsvp.user;
          final name = user?.name ?? 'Unknown';
          final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : AppTheme.grey50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
                  backgroundImage: (user?.image != null && user!.image!.isNotEmpty)
                      ? NetworkImage(user.image!)
                      : null,
                  child: (user?.image == null || user!.image!.isEmpty)
                      ? Text(
                          initial,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.primaryDark,
                        ),
                      ),
                      if (user?.email != null && user!.email.isNotEmpty)
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppTheme.darkTextSecondary : AppTheme.grey600,
                          ),
                        ),
                    ],
                  ),
                ),
                if (rsvp.guestCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${rsvp.guestCount} guest${rsvp.guestCount != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
              ],
            ),
          ).animate().fade(delay: Duration(milliseconds: 50 * index)).slideY(begin: 0.05);
        },
        childCount: list.length,
      ),
    );
  }
}
