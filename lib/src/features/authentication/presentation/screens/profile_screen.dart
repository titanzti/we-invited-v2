import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../constants/app_theme.dart';
import '../controllers/auth_controller.dart';
import '../../data/auth_repository.dart';
import '../../../../common_widgets/global_premium_widgets.dart';

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
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Attempt to get the logged in User from Riverpod State
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: AppTheme.primaryDark),
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).signOut();
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    // Cover Photo
                    Image.network(
                      'https://images.unsplash.com/photo-1519671482749-fd098f3f8a62?q=80&w=1200&auto=format&fit=crop',
                      fit: BoxFit.cover,
                    ).animate().fade(duration: 800.ms),
                    
                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.9),
                            Colors.white,
                          ],
                          stops: const [0.4, 0.9, 1.0],
                        ),
                      ),
                    ),

                    // Avatar & Info
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
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: PremiumShadows.softCard,
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                              child: Text(
                                (user?.name ?? '').isNotEmpty ? (user?.name ?? 'U')[0].toUpperCase() : 'U',
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
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                                ).animate().fade(delay: 200.ms).slideX(),
                                const SizedBox(height: 4),
                                Text(
                                  user?.email ?? 'Not Logged In',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                                ).animate().fade(delay: 300.ms).slideX(),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            
            // Sticky Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppTheme.primaryBlue,
                  labelColor: AppTheme.primaryBlue,
                  unselectedLabelColor: Colors.grey.shade500,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  tabs: const [
                    Tab(text: "Events Joined"),
                    Tab(text: "My Hosted Events"),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Joined
            ListView.builder(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 120),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: PremiumShadows.softCard,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.event_available, color: AppTheme.secondaryTeal),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Awesome Event $index', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text('Tomorrow at 8:00 PM', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(delay: Duration(milliseconds: 100 * index)).slideY();
              },
            ),
            
            // Tab 2: Hosted
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.celebration_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text("You haven't hosted any events yet", style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
