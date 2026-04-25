import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_theme.dart';
import '../../domain/notification_prefs_model.dart';
import '../../presentation/controllers/rsvp_controller.dart';
import '../../../../common_widgets/global_premium_widgets.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  NotificationPrefsModel? _prefs;
  bool _isLoading = true;
  String? _error;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    try {
      final prefs = await ref.read(rsvpControllerProvider.notifier).getNotificationPrefs();
      if (mounted) {
        setState(() {
          _prefs = prefs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load preferences';
          _isLoading = false;
        });
      }
    }
  }

  void _onToggle(bool value, NotificationPrefsModel Function(bool) updater) {
    HapticFeedback.selectionClick();
    setState(() {
      _prefs = updater(value);
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (_prefs == null) return;
      try {
        await ref.read(rsvpControllerProvider.notifier).updateNotificationPrefs(_prefs!);
        if (mounted) {
          PremiumToast.show(context, 'Preferences saved');
        }
      } catch (e) {
        if (mounted) {
          PremiumToast.show(context, 'Failed to save', isError: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.backgroundLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: isDark ? AppTheme.darkBackground : AppTheme.backgroundLight,
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
              'Notifications',
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
                    OutlinedButton(onPressed: _loadPrefs, child: const Text('Retry')),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSwitchTile(
                    icon: Icons.event,
                    title: 'Event Reminders',
                    subtitle: 'Get notified before events start',
                    value: _prefs!.eventReminders,
                    onChanged: (v) => _onToggle(
                      v,
                      (value) => _prefs!.copyWith(eventReminders: value),
                    ),
                    isDark: isDark,
                  ),
                  _buildSwitchTile(
                    icon: Icons.mail_outline,
                    title: 'Invite Alerts',
                    subtitle: 'When someone invites you to an event',
                    value: _prefs!.inviteAlerts,
                    onChanged: (v) => _onToggle(
                      v,
                      (value) => _prefs!.copyWith(inviteAlerts: value),
                    ),
                    isDark: isDark,
                  ),
                  _buildSwitchTile(
                    icon: Icons.people_outline,
                    title: 'RSVP Updates',
                    subtitle: 'When guests respond to your events',
                    value: _prefs!.rsvpUpdates,
                    onChanged: (v) => _onToggle(
                      v,
                      (value) => _prefs!.copyWith(rsvpUpdates: value),
                    ),
                    isDark: isDark,
                  ),
                  _buildSwitchTile(
                    icon: Icons.edit_calendar,
                    title: 'Event Changes',
                    subtitle: 'When event details are updated',
                    value: _prefs!.eventChanges,
                    onChanged: (v) => _onToggle(
                      v,
                      (value) => _prefs!.copyWith(eventChanges: value),
                    ),
                    isDark: isDark,
                  ),
                  _buildSwitchTile(
                    icon: Icons.campaign_outlined,
                    title: 'Marketing Emails',
                    subtitle: 'News, tips, and product updates',
                    value: _prefs!.marketingEmails,
                    onChanged: (v) => _onToggle(
                      v,
                      (value) => _prefs!.copyWith(marketingEmails: value),
                    ),
                    isDark: isDark,
                  ),
                ]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(14),
        border: isDark ? Border.all(color: AppTheme.darkBorder) : null,
        boxShadow: isDark ? null : PremiumShadows.softCard,
      ),
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppTheme.primaryBlue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: AppTheme.caption(isDark)),
      ),
    ).animate().fade().slideY(begin: 0.05);
  }
}
