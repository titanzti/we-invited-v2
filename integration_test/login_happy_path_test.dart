import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login View', () {
    testWidgets('Valid credentials login correctly and navigates to Discover/Home', (tester) async {
      ApiClient.initialize();
      await ApiClient.storage.deleteAll();
      
      app.main();
      
      // Wait for splash and transition to Login Screen
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Welcome\nBack!').evaluate().isNotEmpty) break;
      }

      // Type in credentials
      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 500));

      // 3. Tap Sign In
      await tester.tap(find.byType(AnimatedPrimaryButton));
      
      // Implicitly waits for networking...
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Discover').evaluate().isNotEmpty || find.byType(SnackBar).evaluate().isNotEmpty) break;
      }

      // Explicit assertion: Must go to 'Discover' successfully.
      final isHome = find.text('Discover').evaluate().isNotEmpty;
      
      expect(
        isHome, 
        isTrue, 
        reason: 'Happy path failed! Backend might be down or credentials test@example.com rejected.'
      );
    });
  });
}
