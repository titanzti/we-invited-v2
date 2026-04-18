import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../constants/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';
import '../../../events/data/post_repository.dart';
import '../../../events/domain/post_model.dart';
import '../../../events/presentation/screens/my_rsvps_screen.dart';
import '../../../events/presentation/screens/my_invites_screen.dart';
import '../../../../common_widgets/premium_post_card.dart';
import '../../../../constants/theme_provider.dart';
import '../../../../exceptions/app_exception.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _confirmLogout() async {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
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
            Icon(Icons.logout, size: 40, color: AppTheme.error),
            const SizedBox(height: 16),
            Text('Sign Out?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'You\'ll need to sign in again to access your events.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.error,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      ref.read(authControllerProvider.notifier).signOut();
    }
  }

  String _getUserInitials(UserModel? user) {
    if (user == null) return 'U';
    final name = user.name;
    if (name == null || name.isEmpty) return 'U';
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: isDark ? AppTheme.darkBackground : Colors.white,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: isDark ? AppTheme.darkTextPrimary : AppTheme.primaryDark),
                  onPressed: _confirmLogout,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    // Cover
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryBlue,
                            AppTheme.primaryBlue.withValues(alpha: 0.7),
                            AppTheme.secondaryTeal,
                          ],
                        ),
                      ),
                    ),
                    // Gradient fade
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            (isDark ? AppTheme.darkBackground : Colors.white).withValues(alpha: 0.9),
                            isDark ? AppTheme.darkBackground : Colors.white,
                          ],
                          stops: const [0.3, 0.85, 1.0],
                        ),
                      ),
                    ),

                    // Avatar & info
                    Positioned(
                      bottom: 20,
                      left: 24,
                      right: 24,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.darkSurface : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: PremiumShadows.softCard,
                            ),
                            child: user != null && user.profilePhoto != null && user.profilePhoto!.isNotEmpty
                                ? CircleAvatar(
                                    radius: 40,
                                    backgroundImage: CachedNetworkImageProvider(user.profilePhoto!),
                                  )
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
                                    child: Text(
                                      _getUserInitials(user),
                                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                    ),
                                  ),
                          ).animate().scale(curve: Curves.easeOutBack, duration: 600.ms),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? 'Guest User',
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ).animate().fade(delay: 200.ms).slideX(),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? 'Not Logged In',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark ? AppTheme.darkTextSecondary : Colors.grey.shade600,
                                  ),
                                ).animate().fade(delay: 300.ms).slideX(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.primaryBlue,
                  labelColor: AppTheme.primaryBlue,
                  unselectedLabelColor: isDark ? AppTheme.darkTextSecondary : Colors.grey.shade500,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: const [
                    Tab(text: 'My Events'),
                    Tab(text: 'My RSVPs'),
                    Tab(text: 'Invites'),
                    Tab(text: 'Settings'),
                  ],
                ),
                isDark: isDark,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _MyEventsTab(),

            const MyRSVPsScreen(),

            const MyInvitesScreen(),

            _SettingsTab(),
          ],
        ),
      ),
    );
  }
}

class _MyEventsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MyEventsTab> createState() => _MyEventsTabState();
}

class _MyEventsTabState extends ConsumerState<_MyEventsTab> {
  List<PostModel> _events = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final events = await ref.read(postRepositoryProvider).getMyEvents();
      if (mounted) setState(() { _events = events; _isLoading = false; });
    } catch (e) {
      if (mounted) {
        // Extract user-friendly error message from AppException
        final errorMessage = e is AppException 
            ? e.message 
            : 'Failed to load events. Please try again.';
        setState(() { _error = errorMessage; _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _loadEvents, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No events yet',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Create or join an event to see it here',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 120),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PremiumPostCard(post: event)
                .animate()
                .fade(delay: Duration(milliseconds: 80 * index))
                .slideY(begin: 0.05),
          );
        },
      ),
    );
  }
}

class _SettingsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _settingsTile(
          context,
          icon: Icons.person_outline,
          title: 'Edit Profile',
          subtitle: 'Photo, name, gender',
          isDark: isDark,
          onTap: () => context.push('/profile/edit'),
        ),
        _settingsTile(
          context,
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Event reminders, messages',
          isDark: isDark,
          onTap: () => context.push('/profile/notifications'),
        ),
        _settingsTile(
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
        _settingsTile(
          context,
          icon: Icons.shield_outlined,
          title: 'Privacy',
          subtitle: 'Visibility, data',
          isDark: isDark,
          onTap: () => _showPrivacyInfo(context, isDark),
        ),
        _settingsTile(
          context,
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'Version 2.0.0',
          isDark: isDark,
          onTap: () => _showAboutInfo(context, isDark),
        ),
      ],
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isDark ? Border.all(color: AppTheme.darkBorder) : null,
        boxShadow: isDark ? null : PremiumShadows.softCard,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap?.call();
        },
      ),
    );
  }



  void _showPrivacyInfo(BuildContext context, bool isDark) {
    _showInfoSheet(context: context, isDark: isDark, icon: Icons.shield, title: 'Privacy', body: 'Your profile is visible to event hosts and attendees.\nYour email is never shared publicly.');
  }

  void _showAboutInfo(BuildContext context, bool isDark) {
    _showInfoSheet(context: context, isDark: isDark, icon: Icons.info, title: 'We Invited v2.0.0', body: 'Discover events, invite friends, and manage RSVPs — all in one place.');
  }

  void _showInfoSheet({required BuildContext context, required bool isDark, required IconData icon, required String title, required String body}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Icon(icon, size: 40, color: AppTheme.primaryBlue),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(body, style: TextStyle(color: Colors.grey.shade600, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Navigator.pop(ctx), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Close'))),
        ]),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  _StickyTabBarDelegate(this.tabBar, {this.isDark = false});

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppTheme.darkBackground : Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || isDark != oldDelegate.isDark;
  }
}
