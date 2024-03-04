import 'package:flutter_action_bank/ui/components/messenger.dart';
import 'package:flutter_action_bank/ui/components/page_container.dart';
import 'package:flutter_action_bank/ui/pages/debug.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Pages
import 'package:flutter_action_bank/ui/pages/start.dart';
import 'package:flutter_action_bank/ui/pages/home.dart';
import 'package:flutter_action_bank/ui/pages/login.dart';

import 'package:flutter_action_bank/global_state/authentication_provider.dart';

// final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorHomeKey =
//     GlobalKey<NavigatorState>(debugLabel: 'homePage');
// final _shellNavigatorDebugKey =
//     GlobalKey<NavigatorState>(debugLabel: 'debugPage');

final router = GoRouter(
  redirect: (context, goRouterState) {
    final authProvider = context.read<AuthenticationProvider>();

    if (goRouterState.path != '/login' && authProvider.isAuthenticated) {
      return null;
    }

    return '/login';
  },
  initialLocation: '/',
  routes: [
    // All Routes that need loading screens and snackbars
    ShellRoute(
      builder: (_, __, child) => Messenger(child),
      routes: [
        GoRoute(
          name: 'start',
          path: '/',
          builder: (_, __) => StartPage(),
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (_, __) => LoginPage(),
        ),
        // Authentication Aware Routes & Menu Routes
        StatefulShellRoute.indexedStack(
          builder: (_, __, navigationShell) {
            return NavContainer(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'home',
                  path: '/home',
                  builder: (_, __) => HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'debug',
                  path: '/debug',
                  builder: (_, __) => DebugPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
