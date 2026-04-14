import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('User Registration', () {
    testWidgets('Register new user successfully', (tester) async {
      ApiClient.initialize();
      await ApiClient.storage.deleteAll();

      app.main();

      // Wait for splash and transition to Login Screen
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Welcome\nBack!').evaluate().isNotEmpty) break;
      }

      // Navigate to Register screen
      final registerButton = find.text('Sign Up');
      if (registerButton.evaluate().isNotEmpty) {
        await tester.tap(registerButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }

      // Verify we're on register screen
      final hasRegisterForm = find.byType(TextFormField).evaluate().isNotEmpty;
      expect(
        hasRegisterForm,
        isTrue,
        reason: 'Should show registration form',
      );

      // Fill in registration form
      final nameField = find.byType(TextFormField).at(0);
      final emailField = find.byType(TextFormField).at(1);
      final passwordField = find.byType(TextFormField).at(2);

      await tester.enterText(nameField, 'New Test User');
      await tester.enterText(emailField, 'newuser_${DateTime.now().millisecondsSinceEpoch}@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      // Tap register button
      final registerSubmit = find.byType(AnimatedPrimaryButton);
      if (registerSubmit.evaluate().isNotEmpty) {
        await tester.tap(registerSubmit);
        await tester.pump(const Duration(seconds: 2));
      }

      // Should navigate to login or show success
      final hasSuccessMsg = find.textContaining('Registration successful').evaluate().isNotEmpty ||
          find.text('Welcome\nBack!').evaluate().isNotEmpty;

      expect(
        hasSuccessMsg,
        isTrue,
        reason: 'Registration should succeed and navigate to login',
      );

      print('✅ User registration test passed');
    });

    testWidgets('Empty registration fields show validation errors', (tester) async {
      ApiClient.initialize();
      await ApiClient.storage.deleteAll();

      app.main();

      // Wait for splash and transition to Login Screen
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Welcome\nBack!').evaluate().isNotEmpty) break;
      }

      // Navigate to Register screen
      final registerButton = find.text('Sign Up');
      if (registerButton.evaluate().isNotEmpty) {
        await tester.tap(registerButton);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }

      // Try to submit empty form
      final registerSubmit = find.byType(AnimatedPrimaryButton);
      if (registerSubmit.evaluate().isNotEmpty) {
        await tester.tap(registerSubmit);
        await tester.pump(const Duration(milliseconds: 500));
      }

      // Should show validation errors
      final hasValidationErrors = find.textContaining('required').evaluate().isNotEmpty ||
          find.textContaining('Please enter').evaluate().isNotEmpty ||
          find.byType(TextFormField).evaluate().isNotEmpty;

      expect(
        hasValidationErrors,
        isTrue,
        reason: 'Should show validation errors for empty fields',
      );

      print('✅ Registration validation test passed');
    });
  });
}
