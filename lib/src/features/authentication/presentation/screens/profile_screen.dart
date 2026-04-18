import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import '../../../../constants/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';
import '../../../events/data/post_repository.dart';
import '../../../events/domain/post_model.dart';
import '../../../events/presentation/screens/my_rsvps_screen.dart';
import '../../../events/presentation/screens/my_invites_screen.dart';
import '../../../../constants/theme_provider.dart';
import '../../../../exceptions/app_exception.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _avatarController;
  late AnimationController _statsController;
  late Future<List<int>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  void _initStatsIfNeeded(WidgetRef ref) {
    // Called on first build; safe to call repeatedly — only initializes once.
    // ignore: invalid_use_of_protected_member
    if (!_statsFutureInitialized) {
      _statsFutureInitialized = true;
      _statsFuture = _loadStats(ref);
    }
  }

  bool _statsFutureInitialized = false;

  @override
  void dispose() {
    _tabController.dispose();
    _avatarController.dispose();
    _statsController.dispose();
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
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout_rounded, size: 36, color: AppTheme.error),
            ),
            const SizedBox(height: 20),
            Text(
              'Sign Out',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ll need to sign in again to access\nyour events and RSVPs.',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 15,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.error,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
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
    if (name == null) return 'U';
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return trimmed[0].toUpperCase();
  }

  Future<List<int>> _loadStats(WidgetRef ref) async {
    try {
      final events = await ref.read(postRepositoryProvider).getMyEvents();
      // For now, RSVPs and Invites screens manage their own data
      // Return events count and placeholder for others
      return [events.length, 0, 0];
    } catch (e) {
      return [0, 0, 0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Initialize the stats future once (never on rebuild)
    _initStatsIfNeeded(ref);

    // Dynamic expandedHeight: ~38 % of screen height, clamped between 300–400 dp
    final expandedHeight = (MediaQuery.sizeOf(context).height * 0.38).clamp(300.0, 400.0);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFF8FAFC),
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Ultra Modern Hero Header
            SliverAppBar(
              expandedHeight: expandedHeight,
              pinned: true,
              stretch: true,
              backgroundColor: isDark ? const Color(0xFF09090B) : const Color(0xFFF8FAFC),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.blurBackground,
                  StretchMode.zoomBackground,
                ],
                titlePadding: EdgeInsets.zero,
                background: _buildUltraModernHeader(user, isDark, context, ref),
              ),
            ),

            // High-End Segmented Control Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _ModernTabDelegate(
                TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  unselectedLabelColor: isDark ? Colors.grey.shade600 : const Color(0xFF64748B),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  tabs: const [
                    Tab(text: 'Events'),
                    Tab(text: 'RSVPs'),
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
          physics: const BouncingScrollPhysics(),
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

  Widget _buildUltraModernHeader(UserModel? user, bool isDark, BuildContext context, WidgetRef ref) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dark/Light base
        Container(
          color: isDark ? const Color(0xFF09090B) : const Color(0xFFF1F5F9),
        ),
        // Beautiful glowing orbs in the background
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.3 : 0.15),
                  const Color(0xFF3B82F6).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        // Pre-baked purple orb (cheaper than BackdropFilter blur)
        Positioned(
          bottom: -80,
          left: -120,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.22 : 0.12),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.0),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),

        // Settings / Logout at very top right
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 20,
          child: Row(
            children: [
              _buildGlassButton(Icons.settings_outlined, () => _tabController.animateTo(3), isDark),
              const SizedBox(width: 12),
              _buildGlassButton(Icons.logout_rounded, _confirmLogout, isDark, color: AppTheme.error),
            ],
          ),
        ),

        // Forefront content
        SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Big Profile Picture
              AnimatedBuilder(
                animation: _avatarController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: Curves.easeOutBack.transform(_avatarController.value),
                    child: Hero(
                      tag: 'profile_avatar',
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.02),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black.withValues(alpha: 0.5) : const Color(0xFF3B82F6).withValues(alpha: 0.12),
                              blurRadius: 40,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          backgroundImage: user?.profilePhoto?.isNotEmpty == true
                              ? CachedNetworkImageProvider(user!.profilePhoto!)
                              : null,
                          child: user?.profilePhoto?.isEmpty ?? true
                              ? Text(
                                  _getUserInitials(user),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF3B82F6),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 12),
              
              // Name and Verified Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      user?.name ?? 'Guest User',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.verified_rounded, color: Color(0xFF3B82F6), size: 22),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push('/profile/edit');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit_rounded,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Email pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        user?.email ?? 'Join our community',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24), // Push stats down a bit
              
              // Stat row: use the cached _statsFuture
              FadeTransition(
                opacity: _statsController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: FutureBuilder<List<int>>(
                    future: _statsFuture,
                    builder: (context, snapshot) {
                      final counts = snapshot.data ?? [0, 0, 0];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPureStat('${counts[0]}', 'EVENTS', isDark, () => _tabController.animateTo(0)),
                          _buildPureDivider(isDark),
                          _buildPureStat('${counts[1]}', 'RSVPS', isDark, () => _tabController.animateTo(1)),
                          _buildPureDivider(isDark),
                          _buildPureStat('${counts[2]}', 'INVITES', isDark, () => _tabController.animateTo(2)),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPureStat(String value, String label, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey.shade500 : const Color(0xFF64748B),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPureDivider(bool isDark) {
    return Container(
      height: 32,
      width: 1,
      color: isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFF0F172A).withValues(alpha: 0.1),
    );
  }

  Widget _buildGlassButton(IconData icon, VoidCallback onTap, bool isDark, {Color? color}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 20, color: color ?? (isDark ? Colors.white : const Color(0xFF0F172A))),
          ),
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
        padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 120),
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _CompactEventCard(post: event)
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
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).padding.bottom + 100,
      ),
      children: [
        _buildSettingsSection(
          context,
          isDark: isDark,
          title: 'Account',
          children: [
            _settingsTile(
              context,
              icon: Icons.person_outline_rounded,
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
          ],
        ),
        const SizedBox(height: 20),
        _buildSettingsSection(
          context,
          isDark: isDark,
          title: 'Preferences',
          children: [
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
          ],
        ),
        const SizedBox(height: 20),
        _buildSettingsSection(
          context,
          isDark: isDark,
          title: 'About',
          children: [
            _settingsTile(
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

  Widget _buildSettingsSection(
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
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
            ),
          ),
          child: Column(
            children: children,
          ),
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
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
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
          color: isDark ? AppTheme.darkSurface : Colors.white,
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
                color: Colors.grey.shade300,
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
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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

class _ModernTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  _ModernTabDelegate(this.tabBar, {this.isDark = false});

  @override
  double get minExtent => tabBar.preferredSize.height + 16;

  @override
  double get maxExtent => tabBar.preferredSize.height + 16;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? const Color(0xFF09090B) : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_ModernTabDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || isDark != oldDelegate.isDark;
  }
}

class _CompactEventCard extends StatelessWidget {
  final PostModel post;
  
  const _CompactEventCard({required this.post});

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
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
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
            // Image
            Container(
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
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
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
                        child: Icon(Icons.event_available_rounded, color: Colors.white, size: 36),
                      ),
                    ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
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
                              color: isDark ? Colors.grey.shade400 : const Color(0xFF64748B), 
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_rounded, size: 12, color: isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            post.place.isNotEmpty ? post.place : 'Location TBD', 
                            style: TextStyle(
                              color: isDark ? Colors.grey.shade400 : const Color(0xFF64748B), 
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ), 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
