import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:we_invited_v2/main.dart';
import 'package:we_invited_v2/src/utils/api_client.dart';

void main() {
  testWidgets('App initializes without crashing', (WidgetTester tester) async {
    // Inject ApiClient offline safe mock environment
    ApiClient.initialize();

    // The entire App is now built around Riverpod and GoRouter.
    // We must wrap MyApp with a ProviderScope for it to even boot in testing!
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify system boots up successfully (It usually shows the Splash Screen immediately)
    // For a complex routing app, just proving that it boots without throwing exceptions
    // is a valid baseline smoke test.
    
    // We let the frame trigger without waiting for infinite animations
    await tester.pump(const Duration(seconds: 1));
    
    // This expects at least the Material Layer to be alive
    expect(find.byType(MyApp), findsOneWidget);
  });
}
