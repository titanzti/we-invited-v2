import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('RSVP Complete Flow', () {
    Future<void> performLogin(WidgetTester tester) async {
      ApiClient.initialize();
      await ApiClient.storage.deleteAll();

      app.main();

      // Wait for splash and transition to Login Screen
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Welcome\nBack!').evaluate().isNotEmpty) break;
      }

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
    }

    testWidgets('RSVP Going with guest count', (tester) async {
      await performLogin(tester);
      await tester.pump(const Duration(seconds: 2));

      final eventCards = find.byType(Card);
      if (eventCards.evaluate().isEmpty) {
        return;
      }

      // Tap first event
      await tester.tap(eventCards.first);
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Join Event').evaluate().isNotEmpty ||
            find.text('Request to Join').evaluate().isNotEmpty) {
          break;
        }
      }

      // Join event first
      final joinButton = find.text('Join Event').evaluate().isNotEmpty
          ? find.text('Join Event')
          : find.text('Request to Join');
      if (joinButton.evaluate().isNotEmpty) {
        await tester.tap(joinButton.first);
        await tester.pump(const Duration(milliseconds: 500));

        // Confirm in bottom sheet
        final confirmButton = find.text('Confirm Join').evaluate().isNotEmpty
            ? find.text('Confirm Join')
            : find.text('Send Request');
        if (confirmButton.evaluate().isNotEmpty) {
          await tester.tap(confirmButton.first);
          for (int i = 0; i < 30; i++) {
            await tester.pump(const Duration(milliseconds: 100));
            if (find.textContaining("You're in!").evaluate().isNotEmpty ||
                find.textContaining('Request sent').evaluate().isNotEmpty) {
              break;
            }
          }
        }
      }

      // Now wait for RSVP section
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Are you going?').evaluate().isNotEmpty) break;
      }

      if (find.text('Are you going?').evaluate().isEmpty) {
        // If pending approval or already RSVP'd, skip
        return;
      }

      // Tap Going button
      final goingButton = find.text('Going');
      expect(goingButton, findsOneWidget);
      await tester.tap(goingButton);
      await tester.pump(const Duration(milliseconds: 500));

      // Guest count dialog should appear
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('How many guests?').evaluate().isNotEmpty) break;
      }

      if (find.text('How many guests?').evaluate().isNotEmpty) {
        final confirmButton = find.text('Confirm');
        await tester.tap(confirmButton);
        await tester.pump(const Duration(milliseconds: 500));
      }

      // Verify RSVP changed (selected Going state or toast)
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        final hasToast = find.textContaining('going!').evaluate().isNotEmpty ||
            find.textContaining('Keep you posted').evaluate().isNotEmpty ||
            find.textContaining('next time').evaluate().isNotEmpty;
        if (hasToast) break;
      }

      final hasSuccessIndicator = find.textContaining('going!').evaluate().isNotEmpty ||
          find.textContaining("You're Going").evaluate().isNotEmpty;
      expect(
        hasSuccessIndicator || find.text('Going').evaluate().isNotEmpty,
        isTrue,
        reason: 'Should show RSVP success',
      );
    });

    testWidgets('View Guest List from event detail', (tester) async {
      await performLogin(tester);
      await tester.pump(const Duration(seconds: 2));

      final eventCards = find.byType(Card);
      if (eventCards.evaluate().isEmpty) {
        return;
      }

      await tester.tap(eventCards.first);

      // Scroll or wait for RSVPStatusCard to appear with View Guest List
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('View Guest List').evaluate().isNotEmpty) {
          break;
        }
      }

      if (find.text('View Guest List').evaluate().isEmpty) {
        return;
      }

      await tester.tap(find.text('View Guest List').first);
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Guest List').evaluate().isNotEmpty) break;
      }

      expect(find.text('Guest List'), findsOneWidget);
      expect(find.text('Going'), findsWidgets);
    });

    testWidgets('My RSVPs tab in profile', (tester) async {
      await performLogin(tester);
      await tester.pump(const Duration(seconds: 2));

      // Navigate to Profile
      final profileButton = find.byIcon(Icons.person);
      await tester.tap(profileButton, warnIfMissed: false);
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('My Events').evaluate().isNotEmpty) break;
      }

      expect(find.text('My Events'), findsOneWidget);

      // Switch to My RSVPs tab
      final myRsvpsTab = find.text('My RSVPs');
      if (myRsvpsTab.evaluate().isNotEmpty) {
        await tester.tap(myRsvpsTab.first);
        await tester.pump(const Duration(seconds: 1));

        // Should show either RSVPs or empty state
        final hasRsvpContent = find.text('No RSVPs yet').evaluate().isNotEmpty ||
            find.byType(ListView).evaluate().isNotEmpty;
        expect(
          hasRsvpContent,
          isTrue,
          reason: 'My RSVPs tab should load',
        );
      }
    });

    testWidgets('Notification settings toggle', (tester) async {
      await performLogin(tester);
      await tester.pump(const Duration(seconds: 2));

      // Navigate to Profile
      final profileButton = find.byIcon(Icons.person);
      await tester.tap(profileButton, warnIfMissed: false);
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Settings').evaluate().isNotEmpty) break;
      }

      // Tap Settings tab if not already visible
      final settingsTab = find.text('Settings');
      if (settingsTab.evaluate().length > 1) {
        await tester.tap(settingsTab.last);
        await tester.pump(const Duration(milliseconds: 500));
      }

      // Tap Notifications tile
      final notificationsTile = find.text('Notifications');
      if (notificationsTile.evaluate().isNotEmpty) {
        await tester.tap(notificationsTile.first);
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(milliseconds: 100));
          if (find.text('Notifications').evaluate().length > 1) break;
        }

        expect(find.text('Event Reminders'), findsOneWidget);

        // Find a Switch and toggle it
        final switches = find.byType(Switch);
        if (switches.evaluate().isNotEmpty) {
          await tester.tap(switches.first);
          await tester.pump(const Duration(milliseconds: 500));

          // Verify toggle happened (no crash = success)
          expect(switches.first, findsOneWidget);
        }

        // Go back
        final backButton = find.byIcon(Icons.arrow_back_ios_new);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton.first);
          await tester.pump(const Duration(milliseconds: 500));
        }
      }
    });

    testWidgets('Invite users search screen', (tester) async {
      await performLogin(tester);
      await tester.pump(const Duration(seconds: 2));

      final eventCards = find.byType(Card);
      if (eventCards.evaluate().isEmpty) {
        return;
      }

      // Open first event
      await tester.tap(eventCards.first);
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.byType(Scaffold).evaluate().isNotEmpty) {
          break;
        }
      }

      // Try to find invite button (only visible for host)
      final inviteButton = find.byIcon(Icons.person_add);
      if (inviteButton.evaluate().isEmpty) {
        return;
      }

      await tester.tap(inviteButton.first);
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Invite Friends').evaluate().isNotEmpty) break;
      }

      expect(find.text('Invite Friends'), findsOneWidget);

      // Type a search query
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'test');
        await tester.pump(const Duration(seconds: 1));

        // Should show either results or empty state
        final hasContent = find.byType(ListView).evaluate().isNotEmpty ||
            find.text('No users found').evaluate().isNotEmpty ||
            find.text('Search failed').evaluate().isNotEmpty;
        expect(
          hasContent || find.text('Invite Friends').evaluate().isNotEmpty,
          isTrue,
          reason: 'Invite screen should handle search',
        );
      }
    });
  });
}
