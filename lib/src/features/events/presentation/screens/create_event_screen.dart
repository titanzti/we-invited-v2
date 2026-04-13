import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_event_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_theme.dart';
import '../../../../common_widgets/global_premium_widgets.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _descController = TextEditingController();
  
  String _selectedCategory = 'Party';
  final List<String> _categories = ['Party', 'Networking', 'Dinner', 'Sports', 'Gaming'];

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;
    
    final success = await ref.read(createEventControllerProvider.notifier).createEvent(
      title: _nameController.text.trim(),
      location: _placeController.text.trim(),
      category: _selectedCategory,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event Hosted Successfully!')),
      );
      // Go back to the feed branch
      context.go('/feed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Host Event', 
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Immersive Image Picker
              GestureDetector(
                onTap: () {
                  // TODO: Select image
                },
                child: Container(
                  height: 250,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.grey.shade300, width: 2, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                          ]
                        ),
                        child: const Icon(Icons.add_a_photo_outlined, size: 32, color: AppTheme.primaryBlue),
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                       .scaleXY(begin: 1.0, end: 1.05, duration: 1.seconds),
                      const SizedBox(height: 16),
                      Text(
                        'Upload Event Cover',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
                      )
                    ],
                  ),
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: 0.1),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Event Details', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                        prefixIcon: Icon(Icons.celebration_outlined),
                      ),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ).animate().fade(delay: 100.ms),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _placeController,
                      decoration: const InputDecoration(
                        labelText: 'Location / Address',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ).animate().fade(delay: 200.ms),

                    const SizedBox(height: 16),

                    // Dropdown for Category
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ).animate().fade(delay: 300.ms),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 60), // Align top
                          child: Icon(Icons.description_outlined),
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ).animate().fade(delay: 400.ms),

                    const SizedBox(height: 48),

                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(createEventControllerProvider);
                        final isLoading = state.isLoading;
                        
                        return Column(
                          children: [
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(state.error.toString(), style: const TextStyle(color: Colors.red)),
                              ),
                            AnimatedPrimaryButton(
                              text: isLoading ? 'Publishing...' : 'Publish Event',
                              onPressed: isLoading ? () {} : _submitEvent,
                            ),
                          ],
                        );
                      }
                    ).animate().fade(delay: 500.ms).slideY(begin: 0.2),

                    const SizedBox(height: 120), // Padding for Bottom Nav Bar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
