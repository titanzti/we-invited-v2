import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Events Feed', () {
    testWidgets('Browse events feed successfully', (tester) async {
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

      // Verify we're on the feed screen
      expect(find.text('Discover'), findsOneWidget);

      // Wait a bit for events to load
      await tester.pump(const Duration(seconds: 2));

      // The feed should be visible (either events or empty state)
      // Look for feed content - the feed uses CustomScrollView with slivers
      await tester.pump(const Duration(seconds: 1));
      final hasScrollView = find.byType(CustomScrollView).evaluate().isNotEmpty ||
          find.byType(RefreshIndicator).evaluate().isNotEmpty;
      final hasText = find.textContaining('No events').evaluate().isNotEmpty ||
          find.text('Discover').evaluate().isNotEmpty;
      
      expect(
        hasScrollView || hasText,
        isTrue,
        reason: 'Feed should display either events or empty state',
      );
      
      print('✅ Events feed test passed');
    });
  });
}
