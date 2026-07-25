import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../layout/desktop_shell.dart';
import '../providers/console_providers.dart';
import '../screens/live_board_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/rules_config_screen.dart';
import '../screens/taxonomy_config_screen.dart';
import '../screens/user_management_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/login_screen.dart';

final consoleRouterProvider = Provider<GoRouter>((ref) {
  final userAsync = ref.watch(consoleUserProvider);

  // Shell Navigation keys
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final liveBoardNavigatorKey = GlobalKey<NavigatorState>();
  final analyticsNavigatorKey = GlobalKey<NavigatorState>();
  final rulesNavigatorKey = GlobalKey<NavigatorState>();
  final taxonomyNavigatorKey = GlobalKey<NavigatorState>();
  final usersNavigatorKey = GlobalKey<NavigatorState>();
  final reportsNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/live-board',
    redirect: (context, state) {
      final user = userAsync.valueOrNull;
      final isLoggingIn = state.matchedLocation == '/login';

      if (user == null) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/live-board';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const ConsoleLoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DesktopShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: liveBoardNavigatorKey,
            routes: [
              GoRoute(
                path: '/live-board',
                builder: (context, state) => const LiveBoardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: analyticsNavigatorKey,
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: rulesNavigatorKey,
            routes: [
              GoRoute(
                path: '/rules',
                builder: (context, state) => const RulesConfigScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: taxonomyNavigatorKey,
            routes: [
              GoRoute(
                path: '/taxonomy',
                builder: (context, state) => const TaxonomyConfigScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: usersNavigatorKey,
            routes: [
              GoRoute(
                path: '/users',
                builder: (context, state) => const UserManagementScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: reportsNavigatorKey,
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
