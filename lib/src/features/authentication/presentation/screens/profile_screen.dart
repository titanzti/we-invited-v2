import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';

import '../../../../constants/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_model.dart';
import '../../../events/data/post_repository.dart';
import '../../../events/presentation/screens/my_rsvps_screen.dart';
import '../../../events/presentation/screens/my_invites_screen.dart';
import '../widgets/my_events_tab.dart';
import '../widgets/settings_tab.dart';
import '../widgets/modern_tab_delegate.dart';

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
                color: isDark ? AppTheme.grey400 : AppTheme.grey600,
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
                      side: BorderSide(color: isDark ? AppTheme.grey700 : AppTheme.grey300),
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
                      foregroundColor: AppTheme.surfaceWhite,
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
              delegate: ModernTabDelegate(
                TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: isDark ? AppTheme.surfaceWhite : const Color(0xFF0F172A),
                  unselectedLabelColor: isDark ? AppTheme.grey600 : const Color(0xFF64748B),
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
            const MyEventsTab(),
            const MyRSVPsScreen(),
            const MyInvitesScreen(),
            const SettingsTab(),
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
                          backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppTheme.surfaceWhite,
                          backgroundImage: user?.profilePhoto?.isNotEmpty == true
                              ? CachedNetworkImageProvider(user!.profilePhoto!)
                              : null,
                          child: user?.profilePhoto?.isEmpty ?? true
                              ? Text(
                                  _getUserInitials(user),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppTheme.surfaceWhite : const Color(0xFF3B82F6),
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
                        color: isDark ? AppTheme.surfaceWhite : const Color(0xFF0F172A),
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
                        color: isDark ? AppTheme.surfaceWhite : const Color(0xFF0F172A),
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
                      color: isDark ? AppTheme.grey400 : AppTheme.grey600,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        user?.email ?? 'Join our community',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppTheme.grey400 : AppTheme.grey600,
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
              color: isDark ? AppTheme.surfaceWhite : const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppTheme.grey500 : const Color(0xFF64748B),
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
            child: Icon(icon, size: 20, color: color ?? (isDark ? AppTheme.surfaceWhite : const Color(0xFF0F172A))),
          ),
        ),
      ),
    );
  }
}

