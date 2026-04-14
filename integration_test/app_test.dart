import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:we_invited_v2/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end user flow', () {
    testWidgets('App Boots and displays Splash or Home', (WidgetTester tester) async {
      // Boot up the entire application
      app.main();
      
      // Wait for the app to initialize (avoiding pumpAndSettle due to animations)
      await tester.pump(const Duration(seconds: 2));

      // Assert that MyApp has successfully painted
      expect(find.byType(app.MyApp), findsOneWidget);
    });
  });
}
