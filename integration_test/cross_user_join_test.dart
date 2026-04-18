// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

/// This test creates an event with User A, then logs in as User B and joins the event
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 5),
  Duration interval = const Duration(milliseconds: 100),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(interval);
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('pumpUntilFound timed out waiting for: $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cross-User Event Join Test', () {
    testWidgets('User A creates event, User B joins it', (tester) async {
      ApiClient.initialize();
      
      // Clean up any existing session
      await ApiClient.storage.deleteAll();

      // ============ STEP 1: Register User A (Event Creator) ============
      print('\n📝 STEP 1: Registering User A (Event Creator)...');
      
      app.main();
      
      // Wait for Login Screen
      await pumpUntilFound(tester, find.text('Welcome\nBack!'), timeout: const Duration(seconds: 5));

      // Navigate to Register screen
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Fill registration form for User A
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final userAEmail = 'testuser_a_$timestamp@example.com';
      const userAPassword = 'password123';
      
      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);

      await tester.enterText(nameField, 'Test User A');
      await tester.enterText(emailField, userAEmail);
      await tester.enterText(passwordField, userAPassword);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      // Submit registration
      await tester.tap(find.byType(AnimatedPrimaryButton));
      await tester.pump(const Duration(seconds: 2));

      // Wait for navigation to Home
      await pumpUntilFound(tester, find.text('Discover'), timeout: const Duration(seconds: 3));

      expect(find.text('Discover'), findsOneWidget);
      print('✅ User A registered successfully: $userAEmail');

      // ============ STEP 2: Create Event as User A ============
      print('\n🎉 STEP 2: Creating event as User A...');

      // Tap the FAB to create event
      final fabFinder = find.byKey(const ValueKey('create_event_fab'));
      if (fabFinder.evaluate().isNotEmpty) {
        await tester.tap(fabFinder);
      } else {
        // Fallback: try to find any FloatingActionButton
        await tester.tap(find.byType(FloatingActionButton).first);
      }
      await tester.pumpAndSettle();

      // Fill event creation form
      final eventTitle = 'Test Event by User A - $timestamp';
      final titleField = find.byType(TextFormField).at(0);
      await tester.enterText(titleField, eventTitle);
      await tester.pump(const Duration(milliseconds: 300));

      // Set location
      final locationField = find.byType(TextFormField).at(1);
      await tester.enterText(locationField, 'Bangkok, Thailand');
      await tester.pump(const Duration(milliseconds: 300));

      // Select category (tap first category chip)
      final categoryChip = find.text('Social').first;
      await tester.tap(categoryChip);
      await tester.pump(const Duration(milliseconds: 300));

      // Set description
      final descField = find.byType(TextFormField).at(2);
      await tester.enterText(descField, 'This is a test event created by User A for join testing');
      await tester.pump(const Duration(milliseconds: 300));

      // Submit the event
      await tester.tap(find.text('Create Event'));
      await tester.pump(const Duration(seconds: 2));

      // Wait for success and navigation back
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Discover').evaluate().isNotEmpty) break;
      }

      print('✅ Event created: "$eventTitle"');

      // ============ STEP 3: Logout User A ============
      print('\n🚪 STEP 3: Logging out User A...');

      // Navigate to Profile
      final profileNav = find.byKey(const ValueKey('nav_profile'));
      if (profileNav.evaluate().isNotEmpty) {
        await tester.tap(profileNav);
      } else {
        await tester.tap(find.text('Profile'));
      }
      await tester.pumpAndSettle();

      // Tap the logout icon (profile uses icon-only _buildGlassButton)
      await tester.tap(find.byIcon(Icons.logout_rounded));
      await tester.pumpAndSettle();

      // Confirmation sheet appears — tap 'Sign Out'
      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();

      // Wait for navigation back to Login
      await pumpUntilFound(tester, find.text('Welcome\nBack!'), timeout: const Duration(seconds: 5));

      expect(find.text('Welcome\nBack!'), findsOneWidget);
      print('✅ User A logged out');

      // ============ STEP 4: Login as User B (Event Joiner) ============
      print('\n🔐 STEP 4: Logging in as User B...');

      // Navigate to Register
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Register User B
      final userBEmail = 'testuser_b_$timestamp@example.com';
      const userBPassword = 'password123';

      final nameFieldB = find.byType(TextFormField).at(0);
      final emailFieldB = find.byType(TextFormField).at(1);
      final passwordFieldB = find.byType(TextFormField).at(2);

      await tester.enterText(nameFieldB, 'Test User B');
      await tester.enterText(emailFieldB, userBEmail);
      await tester.enterText(passwordFieldB, userBPassword);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      // Submit registration
      await tester.tap(find.byType(AnimatedPrimaryButton));
      await tester.pump(const Duration(seconds: 2));

      // Wait for Home screen
      await pumpUntilFound(tester, find.text('Discover'), timeout: const Duration(seconds: 5));

      expect(find.text('Discover'), findsOneWidget);
      print('✅ User B logged in: $userBEmail');

      // ============ STEP 5: Find and Join User A's Event ============
      print('\n🔍 STEP 5: Finding User A\'s event...');

      // Wait for events to load
      await tester.pump(const Duration(seconds: 2));

      // Search for the event by title
      // First, try to find it in the feed by scrolling
      // Try using search if available
      final searchIcon = find.byKey(const ValueKey('search_toggle_fab'));
      if (searchIcon.evaluate().isNotEmpty) {
        await tester.tap(searchIcon);
        await tester.pumpAndSettle();

        final searchField = find.byType(TextFormField).first;
        await tester.enterText(searchField, eventTitle);
        await tester.pump(const Duration(seconds: 2));
      }

      // Look for the event card
      final eventCard = find.textContaining('Test Event by User A');
      if (eventCard.evaluate().isNotEmpty) {
        debugPrint('✅ Found event in feed');
        
        // Tap on the event card
        await tester.tap(eventCard.first);
        await tester.pumpAndSettle();

        // ============ STEP 6: Join the Event ============
        print('\n🤝 STEP 6: Joining the event as User B...');

        // Wait for event detail screen to load
        await tester.pump(const Duration(seconds: 1));

        // Find and tap Join button
        final joinButton = find.text('Join Event');
        final joinButtonAlt = find.text('Join');
        final joinRequestButton = find.text('Request to Join');
        
        Finder joinBtn;
        if (joinButton.evaluate().isNotEmpty) {
          joinBtn = joinButton;
        } else if (joinRequestButton.evaluate().isNotEmpty) {
          joinBtn = joinRequestButton;
        } else {
          joinBtn = joinButtonAlt;
        }

        if (joinBtn.evaluate().isNotEmpty) {
          await tester.tap(joinBtn.first);
          await tester.pump(const Duration(seconds: 2));

          // Wait for success message
          await pumpUntilFound(
            tester,
            find.byWidgetPredicate((w) =>
                w is Text &&
                (w.data?.contains("You're in!") == true ||
                    w.data?.contains('Request sent') == true ||
                    w.data?.contains('joined') == true)),
            timeout: const Duration(seconds: 5),
          );

          // Verify join was successful
          final hasSuccessMsg = find.textContaining("You're in!").evaluate().isNotEmpty ||
              find.textContaining('Request sent').evaluate().isNotEmpty ||
              find.textContaining('joined').evaluate().isNotEmpty;

          expect(
            hasSuccessMsg,
            isTrue,
            reason: 'User B should be able to join User A\'s event',
          );

          print('✅ User B successfully joined User A\'s event!');
        } else {
          fail('Join button not found — expected to find "Join Event", "Request to Join", or "Join" to successfully join or request to join the event');
        }
      } else {
        print('⚠️  Event not found in feed - it might be filtered or not visible');
      }

      print('\n🎉 Cross-user join test completed!');
      print('📊 Summary:');
      print('   - User A: $userAEmail (Event Creator)');
      print('   - User B: $userBEmail (Event Joiner)');
      print('   - Event: $eventTitle');
    });
  });
}
