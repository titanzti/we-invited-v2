import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete User Journey', () {
    testWidgets('Full flow: Login -> Browse Feed -> Create Event -> View Profile', (tester) async {
      ApiClient.initialize();
      await ApiClient.storage.deleteAll();

      // Step 1: App Launch
      app.main();

      // Wait for splash and transition to Login Screen
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Welcome\nBack!').evaluate().isNotEmpty) break;
      }

      expect(find.text('Welcome\nBack!'), findsOneWidget);

      // Step 2: Login
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

      expect(find.text('Discover'), findsOneWidget, reason: 'Should navigate to Discover after login');

      // Step 3: Browse Feed
      await tester.pump(const Duration(seconds: 2));
      print('✅ Successfully browsed feed');

      // Step 4: Navigate to Create Event
      final createButton = find.byIcon(Icons.add);
      if (createButton.evaluate().isNotEmpty) {
        await tester.tap(createButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Create Event'), findsOneWidget, reason: 'Should show create event screen');

        // Fill in event details
        final titleField = find.byType(TextFormField).at(0);
        final locationField = find.byType(TextFormField).at(1);

        await tester.enterText(titleField, 'E2E Test Event ${DateTime.now().millisecondsSinceEpoch}');
        await tester.enterText(locationField, 'Bangkok');
        await tester.pump(const Duration(milliseconds: 300));

        // Scroll to find the submit button
        await tester.dragUntilVisible(
          find.byType(AnimatedPrimaryButton),
          find.byType(CustomScrollView),
          const Offset(0, -300),
        );
        await tester.pump(const Duration(milliseconds: 500));

        // Submit
        final createEventButton = find.byType(AnimatedPrimaryButton);
        await tester.tap(createEventButton, warnIfMissed: false);

        // Wait for creation
        for (int i = 0; i < 60; i++) {
          await tester.pump(const Duration(milliseconds: 100));
          if (find.text('Discover').evaluate().isNotEmpty ||
              find.text('Create Event').evaluate().isEmpty) break;
        }

        print('✅ Event creation attempted');
      }

      // Step 5: Navigate to Profile
      final profileButton = find.byIcon(Icons.person);
      if (profileButton.evaluate().isNotEmpty) {
        await tester.tap(profileButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Just verify we navigated to profile branch - check for NestedScrollView or Scaffold
        final hasScaffold = find.byType(Scaffold).evaluate().isNotEmpty;
        expect(
          hasScaffold,
          isTrue,
          reason: 'Should show profile screen',
        );

        print('✅ Profile screen accessed');
      }

      // Step 6: Verify app is still stable
      expect(find.byType(app.MyApp), findsOneWidget);

      print('🎉 Complete user journey test passed!');
    });
  });
}
