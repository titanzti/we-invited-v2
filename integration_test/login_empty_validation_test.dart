import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;
import 'package:we_invited_v2/src/common_widgets/global_premium_widgets.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login View', () {
    testWidgets('Empty fields show validation errors', (WidgetTester tester) async {
      ApiClient.initialize();
      await ApiClient.storage.deleteAll();
      
      app.main();
      
      // Wait for splash and pump to Login Screen
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        if (find.text('Welcome\nBack!').evaluate().isNotEmpty) break;
      }

      // Tap Sign In with empty values
      final signInButton = find.byType(AnimatedPrimaryButton);
      await tester.tap(signInButton);
      await tester.pump(const Duration(milliseconds: 500));

      // Assert error messages appear
      expect(find.text('Please enter email'), findsOneWidget);
      expect(find.text('Please enter password'), findsOneWidget);
    });
  });
}
