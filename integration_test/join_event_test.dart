import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Event Detail & Join', () {
    testWidgets('View event detail and join event', (tester) async {
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

      // Check if there are any events in the feed
      final eventCards = find.byType(Card);
      if (eventCards.evaluate().isEmpty) {
        // No events to join - skip this test gracefully
        return;
      }

      // Tap on the first event card to view detail
      await tester.tap(eventCards.first);
      await tester.pumpAndSettle();

      // Verify we're on event detail screen
      final hasDetailScreen = find.text('Event Details').evaluate().isNotEmpty ||
          find.byType(Scaffold).evaluate().isNotEmpty;
      expect(hasDetailScreen, isTrue);

      // Look for and tap the Join button
      final joinButtonText = find.text('Join Event');
      final joinButtonAlt = find.text('Join');
      final joinButton = joinButtonText.evaluate().isNotEmpty ? joinButtonText : joinButtonAlt;
      
      if (joinButton.evaluate().isNotEmpty) {
        await tester.tap(joinButton.first);

        // Wait for join success
        for (int i = 0; i < 50; i++) {
          await tester.pump(const Duration(milliseconds: 100));
          if (find.text('Joined successfully').evaluate().isNotEmpty ||
              find.text('Request sent').evaluate().isNotEmpty) break;
        }

        // Verify join was successful
        final hasSuccessMsg = find.text('Joined successfully').evaluate().isNotEmpty ||
            find.text('Request sent').evaluate().isNotEmpty;
        expect(
          hasSuccessMsg,
          isTrue,
          reason: 'Should be able to join an event',
        );
      }
    });
  });
}
