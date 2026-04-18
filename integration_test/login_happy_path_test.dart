import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';
import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login View', () {
    testWidgets('Valid credentials login correctly and navigates to Discover/Home', (tester) async {
      ApiClient.initialize();
      await ApiClient.storage.deleteAll();
      
      app.main();
      
      // Wait for login screen
      final loginFound = await TestHelpers.waitForWidget(
        tester,
        find.text('Welcome\nBack!'),
        timeout: const Duration(seconds: 10),
      );
      expect(loginFound, isTrue, reason: 'Should show login screen');

      // Type in credentials
      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      // 3. Tap Sign In
      await tester.tap(find.byType(AnimatedPrimaryButton));
      
      // Wait for navigation to Home/Discover
      final homeFound = await TestHelpers.waitForWidget(
        tester,
        find.text('Discover'),
        timeout: const Duration(seconds: 10),
      );
      
      expect(
        homeFound, 
        isTrue, 
        reason: 'Happy path failed! Backend might be down or credentials test@example.com rejected.'
      );
    });
  });
}
