import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../events/data/post_repository.dart';
import '../../../events/domain/post_model.dart';
import '../../../../exceptions/app_exception.dart';
import '../../../../constants/app_theme.dart';
import 'compact_event_card.dart';

class MyEventsTab extends ConsumerStatefulWidget {
  const MyEventsTab({super.key});

  @override
  ConsumerState<MyEventsTab> createState() => _MyEventsTabState();
}

class _MyEventsTabState extends ConsumerState<MyEventsTab> {
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
            Icon(Icons.cloud_off, size: 48, color: AppTheme.grey300),
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: AppTheme.grey600)),
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
            Icon(Icons.event_note, size: 64, color: AppTheme.grey300),
            const SizedBox(height: 16),
            Text(
              'No events yet',
              style: TextStyle(color: AppTheme.grey500, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Create or join an event to see it here',
              style: TextStyle(color: AppTheme.grey400, fontSize: 14),
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
            child: CompactEventCard(post: event)
                .animate()
                .fade(delay: Duration(milliseconds: 80 * index))
                .slideY(begin: 0.05),
          );
        },
      ),
    );
  }
}
