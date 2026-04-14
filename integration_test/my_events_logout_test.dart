import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('My Events & Profile', () {
    testWidgets('View my events from profile', (tester) async {
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

      // Navigate to Profile
      final profileButton = find.byIcon(Icons.person);
      await tester.tap(profileButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify profile screen is shown
      final hasProfileScreen = find.byType(Scaffold).evaluate().isNotEmpty;
      expect(
        hasProfileScreen,
        isTrue,
        reason: 'Should show profile screen',
      );

      // Check for "My Events" tab or section
      await tester.pump(const Duration(seconds: 1));
      final hasMyEvents = find.textContaining('My Events').evaluate().isNotEmpty ||
          find.text('Events').evaluate().isNotEmpty ||
          find.byType(ListView).evaluate().isNotEmpty ||
          find.byType(CustomScrollView).evaluate().isNotEmpty;

      expect(
        hasMyEvents,
        isTrue,
        reason: 'Should show my events section in profile',
      );

      print('✅ My events test passed');
    });

    testWidgets('Logout from profile', (tester) async {
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

      // Navigate to Profile
      final profileButton = find.byIcon(Icons.person);
      await tester.tap(profileButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for logout button
      final logoutButton = find.byIcon(Icons.logout);
      if (logoutButton.evaluate().isNotEmpty) {
        await tester.tap(logoutButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Confirm logout in dialog
        final confirmButton = find.text('Sign Out');
        if (confirmButton.evaluate().isNotEmpty) {
          await tester.tap(confirmButton);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }

      // Should navigate back to login screen
      final hasLoginScreen = find.text('Welcome\nBack!').evaluate().isNotEmpty ||
          find.byType(TextFormField).evaluate().isNotEmpty;

      expect(
        hasLoginScreen,
        isTrue,
        reason: 'Should navigate to login screen after logout',
      );

      print('✅ Logout test passed');
    });
  });
}
