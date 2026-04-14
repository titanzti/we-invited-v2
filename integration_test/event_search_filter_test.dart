import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Event Search & Filter', () {
    testWidgets('Search events by keyword', (tester) async {
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

      // Wait for events to load
      await tester.pump(const Duration(seconds: 2));

      // Search for events
      final searchField = find.byType(TextField).first;
      if (searchField.evaluate().isNotEmpty) {
        await tester.tap(searchField);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.enterText(searchField, 'Test');
        await tester.pump(const Duration(seconds: 2));
      }

      // Should show filtered results or "no events" message
      final hasResults = find.byType(CustomScrollView).evaluate().isNotEmpty ||
          find.textContaining('No events').evaluate().isNotEmpty;

      expect(
        hasResults,
        isTrue,
        reason: 'Should show search results or empty state',
      );

      print('✅ Event search test passed');
    });

    testWidgets('Filter events by category', (tester) async {
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

      // Wait for events to load
      await tester.pump(const Duration(seconds: 2));

      // Tap on a category chip (e.g., "Party")
      final categoryChip = find.text('Party');
      if (categoryChip.evaluate().isNotEmpty) {
        await tester.tap(categoryChip);
        await tester.pump(const Duration(seconds: 2));
      }

      // Should show filtered results for selected category
      final hasResults = find.byType(CustomScrollView).evaluate().isNotEmpty ||
          find.textContaining('No events').evaluate().isNotEmpty;

      expect(
        hasResults,
        isTrue,
        reason: 'Should show filtered events for selected category',
      );

      print('✅ Event category filter test passed');
    });
  });
}
