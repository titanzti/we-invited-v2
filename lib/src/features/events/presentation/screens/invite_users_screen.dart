import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_theme.dart';
import '../../domain/rsvp_model.dart';
import '../../presentation/controllers/rsvp_controller.dart';
import '../../../../common_widgets/global_premium_widgets.dart';

class InviteUsersScreen extends ConsumerStatefulWidget {
  final String eventId;
  final String eventTitle;

  const InviteUsersScreen({
    super.key,
    required this.eventId,
    required this.eventTitle,
  });

  @override
  ConsumerState<InviteUsersScreen> createState() => _InviteUsersScreenState();
}

class _InviteUsersScreenState extends ConsumerState<InviteUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};
  List<RSVPUserModel> _results = [];
  bool _isSearching = false;
  bool _isSending = false;
  String? _searchError;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
        _searchError = null;
      });
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _searchError = null;
    });
    try {
      final users = await ref.read(rsvpControllerProvider.notifier).searchUsers(query);
      if (mounted) {
        setState(() {
          _results = users;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchError = 'Search failed';
          _isSearching = false;
        });
      }
    }
  }

  Future<void> _sendInvites() async {
    if (_selectedIds.isEmpty) return;
    HapticFeedback.mediumImpact();
    setState(() => _isSending = true);
    try {
      await ref.read(rsvpControllerProvider.notifier).sendInvites(
            widget.eventId,
            _selectedIds.toList(),
          );
      if (mounted) {
        PremiumToast.show(context, 'Invites sent!');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        PremiumToast.show(context, 'Failed to send invites', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackground : Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: isDark ? AppTheme.darkBackground : Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkSurface : Colors.grey.shade100,
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
                  'Invite Friends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.primaryDark,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Text(
                    widget.eventTitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppTheme.darkTextSecondary : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: isDark ? AppTheme.darkSurface : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ).animate().fade().slideY(begin: 0.1),
                ),
              ),
              if (_isSearching)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                )
              else if (_searchError != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(_searchError!, style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ),
                )
              else if (_results.isEmpty && _searchController.text.trim().isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 56, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            'No users found',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final user = _results[index];
                        final isSelected = _selectedIds.contains(user.id);
                        final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              if (isSelected) {
                                _selectedIds.remove(user.id);
                              } else {
                                _selectedIds.add(user.id);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.darkSurface : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(color: AppTheme.primaryBlue, width: 2)
                                  : (isDark ? Border.all(color: AppTheme.darkBorder) : null),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
                                  backgroundImage: (user.image != null && user.image!.isNotEmpty)
                                      ? NetworkImage(user.image!)
                                      : null,
                                  child: (user.image == null || user.image!.isEmpty)
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
                                        user.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: isDark
                                              ? AppTheme.darkTextPrimary
                                              : AppTheme.primaryDark,
                                        ),
                                      ),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppTheme.darkTextSecondary
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.primaryBlue
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.primaryBlue
                                          : (isDark
                                              ? AppTheme.darkBorder
                                              : Colors.grey.shade400),
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ).animate().fade(delay: Duration(milliseconds: 40 * index)).slideY(begin: 0.05);
                      },
                      childCount: _results.length,
                    ),
                  ),
                ),
            ],
          ),
          if (_selectedIds.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBackground : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: AnimatedPrimaryButton(
                  text: _isSending
                      ? 'Sending...'
                      : 'Invite ${_selectedIds.length} user${_selectedIds.length != 1 ? 's' : ''}',
                  onPressed: _isSending ? null : _sendInvites,
                  isLoading: _isSending,
                ),
              ),
            ).animate().slideY(begin: 1.0, duration: 300.ms, curve: Curves.easeOutQuart),
        ],
      ),
    );
  }
}
