import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/edit_event_controller.dart';
import '../../data/post_repository.dart';
import '../../../../constants/app_theme.dart';
import '../../../../common_widgets/global_premium_widgets.dart';
import '../../domain/post_model.dart';
import '../../../../constants/app_constants.dart';

class EditEventScreen extends ConsumerStatefulWidget {
  final PostModel post;
  const EditEventScreen({super.key, required this.post});

  @override
  ConsumerState<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _descController = TextEditingController();
  final _capacityController = TextEditingController();

  String _selectedCategory = 'Party';
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  bool _requiresApproval = false;
  LatLng? _selectedLocation;
  File? _pickedImage;
  bool _hasUnsavedChanges = false;
  bool _isSubmitting = false; // Prevent double submission

  final List<({String name, IconData icon})> _categories = [
    (name: 'Party', icon: Icons.celebration),
    (name: 'Networking', icon: Icons.people),
    (name: 'Dinner', icon: Icons.restaurant),
    (name: 'Sports', icon: Icons.sports_soccer),
    (name: 'Gaming', icon: Icons.sports_esports),
    (name: 'Music', icon: Icons.music_note),
    (name: 'Art', icon: Icons.palette),
  ];

  @override
  void initState() {
    super.initState();
    final post = widget.post;
    _nameController.text = post.name;
    _placeController.text = post.place;
    _descController.text = post.description;
    _capacityController.text = post.numpeople.isNotEmpty ? post.numpeople : '';
    _selectedCategory = post.category.isNotEmpty ? post.category : 'Party';
    _startDate = post.startdateTime;
    _startTime = post.startdateTime != null ? TimeOfDay.fromDateTime(post.startdateTime!) : null;
    _endDate = post.entdateTime;
    _endTime = post.entdateTime != null ? TimeOfDay.fromDateTime(post.entdateTime!) : null;
    _requiresApproval = post.requiresApproval;
    
    if (post.latitude != null && post.longitude != null) {
      _selectedLocation = LatLng(post.latitude!, post.longitude!);
    }
    
    // Add listeners to track changes
    _nameController.addListener(_markChanged);
    _placeController.addListener(_markChanged);
    _descController.addListener(_markChanged);
    _capacityController.addListener(_markChanged);
  }

  void _markChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_markChanged);
    _placeController.removeListener(_markChanged);
    _descController.removeListener(_markChanged);
    _capacityController.removeListener(_markChanged);
    _nameController.dispose();
    _placeController.dispose();
    _descController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    HapticFeedback.selectionClick();
    final now = DateTime.now();
    final existingDate = isStart ? _startDate : _endDate;
    final firstAllowedDate = existingDate != null && existingDate.isBefore(now)
        ? DateTime(existingDate.year, existingDate.month, existingDate.day)
        : DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: existingDate ?? now,
      firstDate: firstAllowedDate,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null || !mounted) return;

    final time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    setState(() {
      if (isStart) {
        _startDate = picked;
        _startTime = time ?? TimeOfDay.now();
      } else {
        _endDate = picked;
        _endTime = time ?? TimeOfDay.now();
      }
      _markChanged(); // Track date/time changes
    });
  }

  DateTime? _combineDateAndTime(DateTime? date, TimeOfDay? time) {
    if (date == null) return null;
    final t = time ?? const TimeOfDay(hour: 0, minute: 0);
    return DateTime(date.year, date.month, date.day, t.hour, t.minute);
  }

  String _formatDateDisplay(DateTime? date, TimeOfDay? time) {
    if (date == null) return 'Select';
    final combined = _combineDateAndTime(date, time)!;
    return DateFormat('EEE, MMM d · h:mm a').format(combined);
  }

  Future<void> _pickLocation() async {
    HapticFeedback.selectionClick();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initial = _selectedLocation ?? const LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude);

    final result = await showModalBottomSheet<LatLng>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationPicker(
        initial: initial,
        isDark: isDark,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
        _markChanged(); // Track location changes
      });
    }
  }

  void _submitEvent() async {
    // Prevent double submission
    if (_isSubmitting) return;
    
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isSubmitting = true);

    String? imageUrl;
    if (_pickedImage != null) {
      try {
        imageUrl = await ref.read(postRepositoryProvider).uploadEventImage(_pickedImage!);
        if (imageUrl == null || imageUrl.isEmpty) {
          throw Exception('Image upload returned no URL');
        }
      } catch (e) {
        if (mounted) {
          PremiumToast.show(context, 'Failed to upload cover photo', isError: true);
          setState(() => _isSubmitting = false);
        }
        return;
      }
    }
    final success = await ref
        .read(editEventControllerProvider.notifier)
        .updateEvent(
          eventId: widget.post.postid,
          title: _nameController.text.trim(),
          location: _placeController.text.trim(),
          category: _selectedCategory,
          description: _descController.text.trim(),
          imageUrl: imageUrl,
          startDateTime: _combineDateAndTime(_startDate, _startTime),
          endDateTime: _combineDateAndTime(_endDate, _endTime),
          maxCapacity: int.tryParse(_capacityController.text.trim()),
          requiresApproval: _requiresApproval,
          latitude: _selectedLocation?.latitude,
          longitude: _selectedLocation?.longitude,
        );

    if (success && mounted) {
      HapticFeedback.heavyImpact();
      PremiumToast.show(context, '🎉 Event updated!');
      _hasUnsavedChanges = false; // Reset flag before popping to prevent discard modal
      context.pop();
    } else if (mounted) {
      setState(() => _isSubmitting = false);
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shouldLeave = await showModalBottomSheet<bool>(
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
            Icon(Icons.warning_amber_rounded, size: 40, color: AppTheme.error),
            const SizedBox(height: 16),
            Text('Discard Changes?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'You have unsaved changes. Are you sure you want to leave?',
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
                    child: const Text('Continue Editing'),
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
                    child: const Text('Discard', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    
    return shouldLeave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(editEventControllerProvider);
    final isLoading = createState.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldLeave = await _onWillPop();
          if (shouldLeave && context.mounted) {
            context.pop();
          }
        },
        child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textMetadata)),
                    const SizedBox(height: 4),
                    Text('Edit Event', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 36)),
                  ],
                ).animate().fade(duration: 500.ms).slideX(begin: -0.05),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Category
                      Text('Category', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 44,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            final isSelected = cat.name == _selectedCategory;
                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _selectedCategory = cat.name;
                                  _markChanged(); // Track category changes
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primaryBlue : (isDark ? AppTheme.darkSurface : Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                  border: isSelected ? null : Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight),
                                ),
                                child: Row(
                                  children: [
                                    Icon(cat.icon, size: 16, color: isSelected ? Colors.white : AppTheme.textMetadata),
                                    const SizedBox(width: 6),
                                    Text(cat.name, style: TextStyle(color: isSelected ? Colors.white : (isDark ? AppTheme.darkTextPrimary : AppTheme.textBody), fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, fontSize: 13)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 28),
                      _buildSectionCard(isDark: isDark, child: TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Event Name', prefixIcon: Icon(Icons.event, size: 20), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none), validator: (v) => v == null || v.isEmpty ? 'Event name is required' : null, enabled: !isLoading)).animate().fade(delay: 300.ms).slideY(begin: 0.05),
                      const SizedBox(height: 16),
                      _buildSectionCard(isDark: isDark, child: TextFormField(controller: _placeController, decoration: const InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.location_on_outlined, size: 20), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none), validator: (v) => v == null || v.isEmpty ? 'Location is required' : null, enabled: !isLoading)).animate().fade(delay: 400.ms).slideY(begin: 0.05),

                      const SizedBox(height: 16),

                      // Map pin
                      GestureDetector(
                        onTap: isLoading ? null : _pickLocation,
                        child: _buildSectionCard(
                          isDark: isDark,
                          child: SizedBox(
                            height: 140,
                            child: _selectedLocation != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      children: [
                                        FlutterMap(
                                          options: MapOptions(
                                            initialCenter: _selectedLocation!,
                                            initialZoom: 15,
                                            interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                                          ),
                                          children: [
                                            TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.weinvited.app'),
                                            MarkerLayer(markers: [
                                              Marker(
                                                point: _selectedLocation!,
                                                width: 40,
                                                height: 40,
                                                child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                                              ),
                                            ]),
                                          ],
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: AppTheme.primaryBlue, borderRadius: BorderRadius.circular(8)),
                                            child: const Text('Change', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_location_alt, size: 32, color: AppTheme.primaryBlue),
                                        const SizedBox(height: 8),
                                        Text('Pin on Map', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600, fontSize: 14)),
                                        const SizedBox(height: 4),
                                        Text('Tap to place your event on the map', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ).animate().fade(delay: 450.ms).slideY(begin: 0.05),

                      const SizedBox(height: 16),

                      // Date & Time
                      Row(children: [
                        Expanded(child: _buildDateTile(isDark: isDark, label: 'Starts', value: _formatDateDisplay(_startDate, _startTime), onTap: isLoading ? null : () => _pickDate(isStart: true))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDateTile(isDark: isDark, label: 'Ends', value: _formatDateDisplay(_endDate, _endTime), onTap: isLoading ? null : () => _pickDate(isStart: false))),
                      ]).animate().fade(delay: 500.ms).slideY(begin: 0.05),

                      const SizedBox(height: 16),
                      _buildSectionCard(isDark: isDark, child: TextFormField(controller: _capacityController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Max Capacity (optional)', prefixIcon: Icon(Icons.people_outline, size: 20), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none), enabled: !isLoading)).animate().fade(delay: 600.ms).slideY(begin: 0.05),

                      const SizedBox(height: 16),
                      _buildSectionCard(isDark: isDark, child: TextFormField(controller: _descController, maxLines: 4, decoration: const InputDecoration(labelText: 'Description (optional)', prefixIcon: Icon(Icons.notes, size: 20), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none), enabled: !isLoading)).animate().fade(delay: 700.ms).slideY(begin: 0.05),

                      const SizedBox(height: 16),

                      // Event image
                      GestureDetector(
                        onTap: isLoading ? null : () async {
                          HapticFeedback.selectionClick();
                          final picked = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            maxWidth: AppConstants.maxImageWidth.toDouble(),
                            imageQuality: AppConstants.imageQuality,
                          );
                          if (picked != null) {
                            setState(() {
                              _pickedImage = File(picked.path);
                              _markChanged(); // Track image changes
                            });
                          }
                        },
                        child: _buildSectionCard(
                          isDark: isDark,
                          child: SizedBox(
                            height: 120,
                            child: _pickedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.file(_pickedImage!, fit: BoxFit.cover),
                                        Positioned(
                                          top: 8, right: 8,
                                          child: GestureDetector(
                                            onTap: () => setState(() => _pickedImage = null),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_photo_alternate_outlined, size: 32, color: AppTheme.primaryBlue),
                                        const SizedBox(height: 8),
                                        Text('Add Cover Photo', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600, fontSize: 14)),
                                        const SizedBox(height: 4),
                                        Text('Optional · Tap to upload', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ).animate().fade(delay: 720.ms).slideY(begin: 0.05),

                      // Approval toggle
                      _buildSectionCard(
                        isDark: isDark,
                        child: SwitchListTile.adaptive(
                          value: _requiresApproval,
                          onChanged: isLoading ? null : (v) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _requiresApproval = v;
                              _markChanged(); // Track approval toggle changes
                            });
                          },
                          activeTrackColor: AppTheme.primaryBlue,
                          title: const Text('Require Approval', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          subtitle: Text(
                            _requiresApproval ? 'You approve each request' : 'Anyone can join instantly',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                          secondary: Icon(
                            _requiresApproval ? Icons.verified_user : Icons.public,
                            color: AppTheme.primaryBlue,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        ),
                      ).animate().fade(delay: 750.ms).slideY(begin: 0.05),

                      const SizedBox(height: 32),
                      AnimatedPrimaryButton(
                        text: 'Save Changes',
                        onPressed: _isSubmitting ? null : _submitEvent,
                        isLoading: _isSubmitting,
                      ).animate().fade(delay: 800.ms).slideY(begin: 0.1),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ), // SafeArea
      ), // PopScope
    ); // Scaffold
  }

  Widget _buildSectionCard({required bool isDark, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight),
        boxShadow: isDark ? null : PremiumShadows.softCard,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: child,
    );
  }

  Widget _buildDateTile({required bool isDark, required String label, required String value, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: isDark ? AppTheme.darkSurface : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight), boxShadow: isDark ? null : PremiumShadows.softCard),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.calendar_today, size: 14, color: AppTheme.primaryBlue),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue, letterSpacing: 0.5)),
          ]),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: value == 'Select' ? (isDark ? AppTheme.darkTextSecondary : AppTheme.textMetadata) : (isDark ? AppTheme.darkTextPrimary : AppTheme.textBody))),
        ]),
      ),
    );
  }
}

class _LocationPicker extends StatefulWidget {
  final LatLng initial;
  final bool isDark;
  const _LocationPicker({required this.initial, required this.isDark});

  @override
  State<_LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<_LocationPicker> {
  late LatLng _pin;

  @override
  void initState() {
    super.initState();
    _pin = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: widget.isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
            child: Column(
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                Text('Pin Your Event', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('Tap on the map to set location', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _pin,
                  initialZoom: 14,
                  onTap: (tapPosition, point) {
                    HapticFeedback.lightImpact();
                    setState(() => _pin = point);
                  },
                ),
                children: [
                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.weinvited.app'),
                  MarkerLayer(markers: [
                    Marker(
                      point: _pin,
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 50),
                    ),
                  ]),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
            child: AnimatedPrimaryButton(
              text: 'Confirm Location',
              onPressed: () => Navigator.pop(context, _pin),
            ),
          ),
        ],
      ),
    );
  }
}
