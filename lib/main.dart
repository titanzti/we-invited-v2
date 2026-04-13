import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/routing/app_router.dart';
import 'src/constants/app_theme.dart';
import 'src/utils/api_client.dart';

// import 'firebase_options.dart'; // Uncomment when generated via flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Dio API Default Configs
  ApiClient.initialize();
  // Firebase uses self-hosted backend API (and feed is mocked), no need to initialize Firebase here.
  runApp(
    // ProviderScope is required to use Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'We Invited V2',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
