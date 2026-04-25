import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_theme.dart';
import '../../../../constants/theme_provider.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 100,
      ),
      children: [
        _buildSection(
          context,
          isDark: isDark,
          title: 'Account',
          children: [
            _buildTile(
              context,
              icon: Icons.person_outline_rounded,
              title: 'Edit Profile',
              subtitle: 'Photo, name, gender',
              isDark: isDark,
              onTap: () => context.push('/profile/edit'),
            ),
            _buildTile(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Event reminders, messages',
              isDark: isDark,
              onTap: () => context.push('/profile/notifications'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          isDark: isDark,
          title: 'Preferences',
          children: [
            _buildTile(
              context,
              icon: Icons.palette_outlined,
              title: 'Appearance',
              subtitle: ref.watch(themeModeProvider) == ThemeMode.system
                  ? 'System'
                  : (isDark ? 'Dark mode' : 'Light mode'),
              isDark: isDark,
              onTap: () async {
                final current = ref.read(themeModeProvider);
                final next = switch (current) {
                  ThemeMode.system => ThemeMode.light,
                  ThemeMode.light => ThemeMode.dark,
                  ThemeMode.dark => ThemeMode.system,
                };
                await ref.read(themeModeProvider.notifier).setThemeMode(next);
              },
            ),
            _buildTile(
              context,
              icon: Icons.shield_outlined,
              title: 'Privacy',
              subtitle: 'Visibility, data',
              isDark: isDark,
              onTap: () => _showPrivacyInfo(context, isDark),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildSection(
          context,
          isDark: isDark,
          title: 'About',
          children: [
            _buildTile(
              context,
              icon: Icons.info_outline_rounded,
              title: 'About We Invited',
              subtitle: 'Version 2.0.0',
              isDark: isDark,
              onTap: () => _showAboutInfo(context, isDark),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? AppTheme.grey400 : AppTheme.grey600,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF2A2A2A) : AppTheme.grey100,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppTheme.grey500 : AppTheme.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppTheme.grey600 : AppTheme.grey400,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyInfo(BuildContext context, bool isDark) {
    _showInfoSheet(
      context: context,
      isDark: isDark,
      icon: Icons.shield_rounded,
      title: 'Privacy',
      body: 'Your profile is visible to event hosts and attendees.\nYour email is never shared publicly.',
    );
  }

  void _showAboutInfo(BuildContext context, bool isDark) {
    _showInfoSheet(
      context: context,
      isDark: isDark,
      icon: Icons.info_rounded,
      title: 'We Invited v2.0.0',
      body: 'Discover events, invite friends, and manage RSVPs — all in one place.',
    );
  }

  void _showInfoSheet({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String title,
    required String body,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Icon(icon, size: 48, color: AppTheme.primaryBlue),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(
                color: isDark ? AppTheme.grey400 : AppTheme.grey600,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
