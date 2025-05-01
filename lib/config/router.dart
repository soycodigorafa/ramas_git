import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import the actual views
import 'package:ramas_git/features/git/view/git_home_view.dart';
import 'package:ramas_git/features/settings/view/settings_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Provider for the GoRouter instance.
/// 
/// Exposes the GoRouter configuration to the rest of the application.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true, // Enable for debugging
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const GitHomeView(), // Use imported view
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsView(), // Use imported view
      ),
    ],
    // Optional: Add error handling/redirection if needed
    // errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});
