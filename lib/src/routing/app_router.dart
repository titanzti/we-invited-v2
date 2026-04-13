import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/events/presentation/screens/home_screen.dart';
import '../features/events/presentation/screens/event_detail_screen.dart';
import '../features/events/presentation/screens/create_event_screen.dart';
import '../features/events/domain/post_model.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/authentication/presentation/screens/register_screen.dart';
import '../features/authentication/presentation/screens/profile_screen.dart';
import 'splash_screen.dart';
import 'main_scaffold.dart';
import '../features/authentication/data/auth_repository.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorFeedKey = GlobalKey<NavigatorState>(debugLabel: 'feed');
final _shellNavigatorCreateKey = GlobalKey<NavigatorState>(debugLabel: 'create');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final isGoingToSplash = state.uri.path == '/splash';
      final isGoingToLogin = state.uri.path == '/login';
      final isGoingToRegister = state.uri.path == '/register';

      if (authState.isLoading && isGoingToSplash) return null;

      final isAuth = authState.value != null;

      if (!isAuth && !isGoingToLogin && !isGoingToRegister) {
        return '/login';
      }
      
      if (isAuth && (isGoingToLogin || isGoingToRegister || isGoingToSplash)) {
        return '/feed'; // Default tab
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Bottom Navigation Architecture
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Feed
          StatefulShellBranch(
            navigatorKey: _shellNavigatorFeedKey,
            routes: [
              GoRoute(
                path: '/feed',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'event', // /feed/event
                    parentNavigatorKey: _rootNavigatorKey, // Overlay shell
                    builder: (context, state) {
                      final post = state.extra as PostModel?;
                      if (post == null) {
                        return const Scaffold(body: Center(child: Text('Event not found!')));
                      }
                      return EventDetailScreen(post: post);
                    },
                  ),
                ],
              ),
            ],
          ),
          
          // Branch 1: Create
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCreateKey,
            routes: [
              GoRoute(
                path: '/create',
                builder: (context, state) => const CreateEventScreen(),
              ),
            ],
          ),
          
          // Branch 2: Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      )
    ],
  );
});
