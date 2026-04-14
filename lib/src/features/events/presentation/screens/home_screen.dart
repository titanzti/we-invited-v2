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
import '../../domain/post_model.dart';
import '../../../../common_widgets/feed_skeleton_loader.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
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
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.mediumImpact();
    ref.invalidate(feedControllerProvider);
    await ref.read(feedControllerProvider.future);
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() {});
    });
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isMapView ? _buildMapView(feedState, isDark) : _buildListView(feedState, isDark),
    );
  }

  // ============== MAP VIEW ==============
  Widget _buildMapView(AsyncValue<List<PostModel>> feedState, bool isDark) {
    return Stack(
      children: [
        // Full screen map
        feedState.when(
          data: (posts) {
            final filtered = _filterPosts(posts);
            final eventsWithCoords = filtered.where((p) => p.latitude != null && p.longitude != null).toList();
            final center = eventsWithCoords.isNotEmpty
                ? LatLng(eventsWithCoords.first.latitude!, eventsWithCoords.first.longitude!)
                : const LatLng(13.7563, 100.5018);

            return FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 13,
                onTap: (_, __) => setState(() => _selectedMapEvent = null),
              ),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.weinvited.app'),
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
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() => _selectedMapEvent = post);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppTheme.primaryBlue : Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.primaryBlue, width: 2.5),
                                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))],
                                  ),
                                  child: Icon(
                                    _categoryIcons[post.category] ?? Icons.event,
                                    color: isSelected ? Colors.white : AppTheme.primaryBlue,
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
          loading: () => Container(color: isDark ? AppTheme.darkBackground : Colors.grey.shade200, child: const Center(child: CircularProgressIndicator())),
          error: (_, __) => Container(color: isDark ? AppTheme.darkBackground : Colors.grey.shade200, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.cloud_off, size: 48, color: Colors.grey.shade400), const SizedBox(height: 8), TextButton(onPressed: _onRefresh, child: const Text('Retry'))]))),
        ),

        // Overlay: header
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: _buildOverlayHeader(isDark),
          ),
        ),

        // Overlay: category chips
        Positioned(
          top: MediaQuery.of(context).padding.top + (_isSearching ? 130 : 90),
          left: 0,
          right: 0,
          child: _buildCategoryChips(isDark),
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
  Widget _buildListView(AsyncValue<List<PostModel>> feedState, bool isDark) {
    return RefreshIndicator.adaptive(
      onRefresh: _onRefresh,
      color: AppTheme.primaryBlue,
      child: CustomScrollView(
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
            data: (posts) {
              final filtered = _filterPosts(posts);
              if (filtered.isEmpty) {
                return SliverFillRemaining(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300), const SizedBox(height: 16), Text(_searchController.text.isNotEmpty ? 'No events match your search' : _selectedCategory != 'All' ? 'No $_selectedCategory events right now' : 'No events happening right now', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)), const SizedBox(height: 8), Text('Pull down to refresh', style: TextStyle(color: Colors.grey.shade400, fontSize: 13))])));
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: PremiumPostCard(post: post).animate().fade(delay: Duration(milliseconds: 80 * (index % 5))).slideY(begin: 0.08),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(child: FeedSkeletonLoader()),
            error: (err, st) => SliverFillRemaining(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.cloud_off, size: 48, color: Colors.grey.shade300), const SizedBox(height: 16), Text('Failed to load events', style: TextStyle(color: Colors.grey.shade600)), const SizedBox(height: 8), TextButton(onPressed: _onRefresh, child: const Text('Tap to retry'))]))),
          ),
        ],
      ),
    );
  }

  // ============== SHARED WIDGETS ==============

  Widget _buildOverlayHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
          (isDark ? AppTheme.darkBackground : Colors.white).withValues(alpha: 0.95),
          (isDark ? AppTheme.darkBackground : Colors.white).withValues(alpha: 0),
        ]),
      ),
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
                onTap: () {
                  setState(() => _isSearching = !_isSearching);
                  if (!_isSearching) _searchController.clear();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: PremiumShadows.softCard),
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
                        fillColor: isDark ? AppTheme.darkSurface : Colors.white,
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
            onTap: () {
              setState(() => _isSearching = !_isSearching);
              if (!_isSearching) _searchController.clear();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: PremiumShadows.softCard),
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
                decoration: InputDecoration(hintText: 'Search events, places...', prefixIcon: const Icon(Icons.search, size: 20), filled: true, fillColor: isDark ? AppTheme.darkSurface : Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
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
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedCategory = cat);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryBlue : (isDark ? AppTheme.darkSurface : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? null : Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(children: [
                Icon(_categoryIcons[cat] ?? Icons.category, size: 16, color: isSelected ? Colors.white : AppTheme.textMetadata),
                const SizedBox(width: 6),
                Text(cat, style: TextStyle(color: isSelected ? Colors.white : (isDark ? AppTheme.darkTextPrimary : AppTheme.textBody), fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, fontSize: 13)),
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
        decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: PremiumShadows.softCard),
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
          color: isDark ? AppTheme.darkSurface : Colors.white,
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
                          Icon(Icons.verified_user, size: 14, color: Colors.orange.shade700),
                        ],
                        const Spacer(),
                        GestureDetector(onTap: onClose, child: Icon(Icons.close, size: 18, color: Colors.grey.shade400)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(post.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.location_on_outlined, size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 3),
                      Expanded(child: Text(post.place, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis)),
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
class PremiumPostCard extends StatelessWidget {
  final PostModel post;
  const PremiumPostCard({super.key, required this.post});

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
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight, width: 1),
          boxShadow: isDark ? null : PremiumShadows.softCard,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(children: [
              Hero(
                tag: 'event_image_${post.postid}',
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: post.image.isNotEmpty
                      ? CachedNetworkImage(imageUrl: post.image, fit: BoxFit.cover, placeholder: (context, url) => Container(color: isDark ? AppTheme.darkSurface : AppTheme.borderLight), errorWidget: (context, url, error) => Container(color: isDark ? AppTheme.darkSurface : AppTheme.borderLight, child: const Icon(Icons.image_not_supported, color: Colors.grey)))
                      : Container(color: AppTheme.primaryBlue.withValues(alpha: 0.1), child: const Icon(Icons.event, size: 48, color: AppTheme.primaryBlue)),
                ),
              ),
              if (dateLabel.isNotEmpty)
                Positioned(top: 12, right: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)), child: Text(dateLabel, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)))),
              if (post.requiresApproval)
                Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.orange.shade700, borderRadius: BorderRadius.circular(8)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.verified_user, size: 12, color: Colors.white), SizedBox(width: 4), Text('Approval', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))]))),
            ]),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  if (post.category.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: isDark ? AppTheme.primaryBlue.withValues(alpha: 0.2) : const Color(0xFFF2F9FF), borderRadius: BorderRadius.circular(9999)), child: Text(post.category, style: Theme.of(context).textTheme.labelSmall)),
                  Icon(Icons.favorite_border, color: isDark ? AppTheme.darkTextSecondary : AppTheme.primaryDark, size: 20),
                ]),
                const SizedBox(height: 10),
                Hero(tag: 'post_title_${post.postid}', child: Text(post.name.isNotEmpty ? post.name : 'Untitled Event', style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(post.place.isNotEmpty ? post.place : 'Location TBD', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  if (post.numpeople.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.people_outline, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(post.numpeople, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ],
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
