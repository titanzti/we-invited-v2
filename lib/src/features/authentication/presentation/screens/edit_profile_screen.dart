import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants/app_theme.dart';
import '../../../../common_widgets/global_premium_widgets.dart';
import '../../data/auth_repository.dart';
import '../controllers/profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  String _selectedGender = 'Secret';
  File? _pickedImage;
  bool _isSaving = false;

  final _genderOptions = ['Male', 'Female', 'Non-binary', 'Secret'];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).value;
    if (user != null) {
      _nameController.text = user.name ?? '';
      _selectedGender = user.gender ?? 'Secret';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    HapticFeedback.selectionClick();
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      PremiumToast.show(context, 'Name is required', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final controller = ref.read(profileControllerProvider.notifier);
      if (_pickedImage != null) {
        await controller.updateProfilePhoto(_pickedImage!);
        final photoState = ref.read(profileControllerProvider);
        if (photoState.hasError) throw photoState.error!;
      }

      await controller.updateProfile(
        name: name,
        gender: _selectedGender,
      );
      final profileState = ref.read(profileControllerProvider);
      if (profileState.hasError) throw profileState.error!;

      if (mounted) {
        HapticFeedback.heavyImpact();
        PremiumToast.show(context, '✅ Profile updated!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        PremiumToast.show(context, 'Failed to update profile', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            GestureDetector(
              onTap: _isSaving ? null : _pickImage,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryBlue, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : (user?.profilePhoto != null && user!.profilePhoto!.isNotEmpty
                              ? NetworkImage(user.profilePhoto!) as ImageProvider
                              : null),
                      child: _pickedImage == null && (user?.profilePhoto == null || user!.profilePhoto!.isEmpty)
                          ? Text(
                              ((user?.name?.isNotEmpty ?? false) ? user!.name![0] : 'U').toUpperCase(),
                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? AppTheme.darkBackground : AppTheme.surfaceWhite, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, color: AppTheme.surfaceWhite, size: 16),
                    ),
                  ),
                ],
              ),
            ).animate().scale(curve: Curves.easeOutBack, duration: 500.ms),

            const SizedBox(height: 32),

            // Name
            _buildField(
              isDark: isDark,
              child: TextFormField(
                controller: _nameController,
                enabled: !_isSaving,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ).animate().fade(delay: 200.ms).slideY(begin: 0.05),

            const SizedBox(height: 16),

            // Gender
            _buildField(
              isDark: isDark,
              child: DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.wc, size: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                items: _genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: _isSaving ? null : (v) => setState(() => _selectedGender = v ?? 'Secret'),
              ),
            ).animate().fade(delay: 300.ms).slideY(begin: 0.05),

            const SizedBox(height: 16),

            // Email (read-only)
            _buildField(
              isDark: isDark,
              child: TextFormField(
                initialValue: user?.email ?? '',
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ).animate().fade(delay: 400.ms).slideY(begin: 0.05),

            const SizedBox(height: 40),

            AnimatedPrimaryButton(
              text: 'Save Changes',
              onPressed: _isSaving ? null : _save,
              isLoading: _isSaving,
            ).animate().fade(delay: 500.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildField({required bool isDark, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.borderLight),
        boxShadow: isDark ? null : PremiumShadows.softCard,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: child,
    );
  }
}
