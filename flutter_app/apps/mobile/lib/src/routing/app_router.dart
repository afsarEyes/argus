import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:argus_core/argus_core.dart';
import '../screens/login_screen.dart';
import '../screens/queue_screen.dart';
import '../screens/flag_issue_screen.dart';
import '../screens/all_tickets_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/ticket_detail_screen.dart';

part 'app_router.g.dart';

@riverpod
Stream<User?> appUserStream(AppUserStreamRef ref) {
  return ref.watch(authRepositoryProvider).currentUserStream;
}

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    ref.listen(appUserStreamProvider, (previous, next) {
      notifyListeners();
    });
  }
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final userAsync = ref.watch(appUserStreamProvider);
  debugPrint('appRouter: userAsync state is $userAsync, value is ${userAsync.valueOrNull}');
  final user = userAsync.valueOrNull;

  final notifier = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: '/queue',
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      debugPrint('Router Redirect: user=$user, matchedLocation=${state.matchedLocation}, loggingIn=$loggingIn');
      if (user == null) {
        return '/login';
      }
      if (loggingIn) {
        return '/queue';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Prevent index shifting when tabs are dynamically hidden
          final showSupervisorTab = user != null && user.role != UserRole.staff;
          final List<int> tabToBranchIndex = [
            0, // Queue
            1, // Flag
            if (showSupervisorTab) 2, // All Tickets
            3, // Alerts
            4, // Profile
          ];

          final activeIndex = tabToBranchIndex.indexOf(navigationShell.currentIndex);

          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: activeIndex >= 0 ? activeIndex : 0,
              onTap: (index) {
                if (index >= 0 && index < tabToBranchIndex.length) {
                  navigationShell.goBranch(tabToBranchIndex[index]);
                }
              },
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Queue',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  label: 'Flag',
                ),
                if (showSupervisorTab)
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'All Tickets',
                  ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Alerts',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/queue',
                builder: (context, state) => const MyQueueScreen(),
                routes: [
                  GoRoute(
                    path: 'tickets/:id',
                    builder: (context, state) => TicketDetailScreen(
                      ticketId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/flag-issue',
                builder: (context, state) => const FlagIssueScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/all-tickets',
                builder: (context, state) => const AllTicketsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                builder: (context, state) => const NotificationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
