import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import '../controllers/feed_controller.dart';
import '../../../../constants/app_theme.dart';
import '../../../../constants/app_constants.dart';
import '../../domain/post_model.dart';
import '../../../../common_widgets/feed_skeleton_loader.dart';
import '../../../../common_widgets/premium_post_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MapController _mapController = MapController();
  Timer? _debounce;
  bool _isSearching = false;
  bool _isMapView = true;
  PostModel? _selectedMapEvent;

  final List<String> _categories = [
    'All', 'Party', 'Networking', 'Dinner', 'Sports', 'Gaming', 'Music', 'Art',
  ];

  static const _categoryIcons = {
    'All': Icons.explore,
    'Party': Icons.celebration,
    'Networking': Icons.people,
    'Dinner': Icons.restaurant,
    'Sports': Icons.sports_soccer,
    'Gaming': Icons.sports_esports,
    'Music': Icons.music_note,
    'Art': Icons.palette,
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    ref.invalidate(feedControllerProvider);
    await ref.read(feedControllerProvider.future);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - AppConstants.loadMoreThreshold) {
      ref.read(feedControllerProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: AppConstants.searchDebounceMs), () {
      setState(() {});
      if (_isMapView) _recenterMap();
    });
  }

  void _recenterMap() {
    if (!_isMapView) return;
    final feedData = ref.read(feedControllerProvider).valueOrNull;
    if (feedData == null) return;
    final filtered = _filterPosts(feedData.posts);
    final withCoords = filtered
        .where((p) => p.latitude != null && p.longitude != null)
        .toList();
    final target = withCoords.isNotEmpty
        ? LatLng(withCoords.first.latitude!, withCoords.first.longitude!)
        : const LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude);
    _mapController.move(target, 13);
  }

  List<PostModel> _filterPosts(List<PostModel> posts) {
    var filtered = posts;
    if (_selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((p) => p.name.toLowerCase().contains(query) || p.place.toLowerCase().contains(query) || p.description.toLowerCase().contains(query)).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemStatusBarContrastEnforced: true,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _isMapView ? _buildMapView(feedState, isDark) : _buildListView(feedState, isDark),
      ),
    );
  }

  // ============== MAP VIEW ==============
  Widget _buildMapView(AsyncValue<FeedState> feedState, bool isDark) {
    return Stack(
      children: [
        feedState.when(
          data: (state) {
            final filtered = _filterPosts(state.posts);
            final eventsWithCoords =
                filtered.where((p) => p.latitude != null && p.longitude != null).toList();
            final initialCenter = eventsWithCoords.isNotEmpty
                ? LatLng(eventsWithCoords.first.latitude!, eventsWithCoords.first.longitude!)
                : const LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude);

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: 13,
                onTap: (_, __) => setState(() => _selectedMapEvent = null),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.weinvited.app',
                ),
                MarkerLayer(
                  markers: [
                    for (final post in eventsWithCoords)
                      if (post.latitude case final lat?)
                        if (post.longitude case final lng?)
                          () {
                            final isSelected = _selectedMapEvent?.postid == post.postid;
                            return Marker(
                              point: LatLng(lat, lng),
                              width: isSelected ? 52 : 44,
                              height: isSelected ? 52 : 44,
                              child: GestureDetector(
                                key: ValueKey('event_marker_${post.postid}'),
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() => _selectedMapEvent = post);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppTheme.primaryBlue : AppTheme.surfaceWhite,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.primaryBlue, width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _categoryIcons[post.category] ?? Icons.event,
                                    color: isSelected ? AppTheme.surfaceWhite : AppTheme.primaryBlue,
                                    size: isSelected ? 24 : 20,
                                  ),
                                ),
                              ),
                            );
                          }(),
                  ],
                ),
              ],
            );
          },
          loading: () => Container(
            color: isDark ? AppTheme.darkBackground : AppTheme.grey200,
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => Container(
            color: isDark ? AppTheme.darkBackground : AppTheme.grey200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 48, color: AppTheme.grey400),
                  const SizedBox(height: 8),
                  TextButton(onPressed: _onRefresh, child: const Text('Retry')),
                ],
              ),
            ),
          ),
        ),

        // Overlay: header and chips
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 44),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildOverlayHeader(isDark),
                      _buildCategoryChips(isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Selected event card
        if (_selectedMapEvent != null)
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: _MapEventCard(
              post: _selectedMapEvent!,
              isDark: isDark,
              onTap: () => context.push('/feed/event', extra: _selectedMapEvent!),
              onClose: () => setState(() => _selectedMapEvent = null),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.15),
          ),

        // View toggle FAB
        Positioned(
          bottom: 130,
          right: 20,
          child: _buildViewToggle(isDark),
        ),
      ],
    );
  }

  // ============== LIST VIEW ==============
  Widget _buildListView(AsyncValue<FeedState> feedState, bool isDark) {
    return RefreshIndicator.adaptive(
      onRefresh: _onRefresh,
      color: AppTheme.primaryBlue,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildListHeader(isDark),
                    _buildSearchBar(isDark),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildCategoryChips(isDark)),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          feedState.when(
            data: (state) {
              final filtered = _filterPosts(state.posts);
              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: AppTheme.grey300),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? 'No events match your search'
                              : _selectedCategory != 'All'
                                  ? 'No $_selectedCategory events right now'
                                  : 'No events happening right now',
                          style: TextStyle(color: AppTheme.grey500, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text('Pull down to refresh',
                            style: TextStyle(color: AppTheme.grey400, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: PremiumPostCard(
                          key: ValueKey('event_card_${post.postid}'),
                          post: post,
                        )
                            .animate()
                            .fade(delay: Duration(milliseconds: 80 * (index % 5)))
                            .slideY(begin: 0.08),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(child: FeedSkeletonLoader()),
            error: (err, st) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, size: 48, color: AppTheme.grey300),
                    const SizedBox(height: 16),
                    Text('Failed to load events',
                        style: TextStyle(color: AppTheme.grey600)),
                    const SizedBox(height: 8),
                    TextButton(onPressed: _onRefresh, child: const Text('Tap to retry')),
                  ],
                ),
              ),
            ),
          ),
          // Load more indicator
          SliverToBoxAdapter(
            child: feedState.valueOrNull?.isLoadingMore == true
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  // ============== SHARED WIDGETS ==============

  Widget _buildOverlayHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Discover', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textMetadata)),
                const SizedBox(height: 2),
                Text('Events', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28)),
              ]),
              GestureDetector(
                key: const ValueKey('search_toggle_button'),
                onTap: () {
                  setState(() => _isSearching = !_isSearching);
                  if (!_isSearching) _searchController.clear();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(12), boxShadow: PremiumShadows.softCard),
                  child: Icon(_isSearching ? Icons.close : Icons.search, color: AppTheme.primaryBlue, size: 22),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isSearching
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Discover', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textMetadata)),
          const SizedBox(height: 4),
          Text('Events', style: Theme.of(context).textTheme.displayMedium),
        ]),
        Row(children: [
          _buildViewToggle(isDark),
          const SizedBox(width: 10),
          GestureDetector(
            key: const ValueKey('search_toggle_fab'),
            onTap: () {
              setState(() => _isSearching = !_isSearching);
              if (!_isSearching) _searchController.clear();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(12), boxShadow: PremiumShadows.softCard),
              child: Icon(_isSearching ? Icons.close : Icons.search, color: AppTheme.primaryBlue),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isSearching
          ? Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(hintText: 'Search events, places...', prefixIcon: const Icon(Icons.search, size: 20), filled: true, fillColor: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildCategoryChips(bool isDark) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            key: ValueKey('category_chip_$cat'),
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedCategory = cat);
              if (_isMapView) _recenterMap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryBlue : (isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite),
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? null : Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(children: [
                Icon(_categoryIcons[cat] ?? Icons.category, size: 16, color: isSelected ? AppTheme.surfaceWhite : AppTheme.textMetadata),
                const SizedBox(width: 6),
                Text(cat, style: TextStyle(color: isSelected ? AppTheme.surfaceWhite : (isDark ? AppTheme.darkTextPrimary : AppTheme.textBody), fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, fontSize: 13)),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildViewToggle(bool isDark) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _isMapView = !_isMapView;
          _selectedMapEvent = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite, borderRadius: BorderRadius.circular(12), boxShadow: PremiumShadows.softCard),
        child: Icon(_isMapView ? Icons.view_list : Icons.map, color: AppTheme.primaryBlue, size: 22),
      ),
    );
  }
}

// ============== MAP EVENT CARD ==============
class _MapEventCard extends StatelessWidget {
  final PostModel post;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onClose;
  const _MapEventCard({required this.post, required this.isDark, required this.onTap, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: SizedBox(
                width: 100,
                height: 100,
                child: post.image.isNotEmpty
                    ? CachedNetworkImage(imageUrl: post.image, fit: BoxFit.cover)
                    : Container(color: AppTheme.primaryBlue.withValues(alpha: 0.1), child: const Icon(Icons.event, color: AppTheme.primaryBlue)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppTheme.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: Text(post.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue)),
                        ),
                        if (post.requiresApproval) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.verified_user, size: 14, color: AppTheme.semanticOrangeDark),
                        ],
                        const Spacer(),
                        GestureDetector(onTap: onClose, child: Icon(Icons.close, size: 18, color: AppTheme.grey400)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(post.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.location_on_outlined, size: 13, color: AppTheme.grey500),
                      const SizedBox(width: 3),
                      Expanded(child: Text(post.place, style: TextStyle(fontSize: 12, color: AppTheme.grey600), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
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

// ============== PREMIUM POST CARD (LIST VIEW) ==============

