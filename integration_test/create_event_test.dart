import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Create Event', () {
    testWidgets('Create a new event successfully', (tester) async {
      ApiClient.initialize();
      await ApiClient.storage.deleteAll();

      app.main();

      // Wait for splash and transition to Login Screen
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Welcome\nBack!').evaluate().isNotEmpty) break;
      }

      // Login first
      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byType(AnimatedPrimaryButton));

      // Wait for navigation to Home/Discover
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Discover').evaluate().isNotEmpty) break;
      }

      expect(find.text('Discover'), findsOneWidget);

      // Navigate to Create Event screen via bottom navigation (Host button)
      // Need to scroll up to make sure the button is visible
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      
      final createButton = find.byIcon(Icons.add);
      await tester.tap(createButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify we're on the create event screen - check for form fields
      final hasTitleField = find.byType(TextFormField).evaluate().isNotEmpty;
      final hasLocationField = find.byType(TextFormField).at(1).evaluate().isNotEmpty;

      expect(
        hasTitleField && hasLocationField,
        isTrue,
        reason: 'Should show create event screen with title and location fields',
      );

      // Fill in event details
      final titleField = find.byType(TextFormField).at(0);
      final locationField = find.byType(TextFormField).at(1);

      await tester.enterText(titleField, 'E2E Test Event ${DateTime.now().millisecondsSinceEpoch}');
      await tester.enterText(locationField, 'Bangkok, Thailand');
      await tester.pump(const Duration(milliseconds: 300));

      // Scroll to find the submit button
      await tester.dragUntilVisible(
        find.byType(AnimatedPrimaryButton),
        find.byType(CustomScrollView),
        const Offset(0, -300),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Tap create button (AnimatedPrimaryButton)
      final createEventButton = find.byType(AnimatedPrimaryButton);
      await tester.tap(createEventButton);

      // Wait for success or navigation
      for (int i = 0; i < 80; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        // Should navigate back to feed or show success
        if (find.text('Discover').evaluate().isNotEmpty ||
            find.text('🎉 Event created!').evaluate().isNotEmpty) break;
      }

      // Verify event was created (should navigate back to feed or show toast)
      final isOnFeed = find.text('Discover').evaluate().isNotEmpty;
      final hasSuccessToast = find.text('🎉 Event created!').evaluate().isNotEmpty;
      
      expect(
        isOnFeed || hasSuccessToast,
        isTrue,
        reason: 'Event creation should succeed and navigate back to feed',
      );
      
      print('✅ Create event test passed');
    });
  });
}
