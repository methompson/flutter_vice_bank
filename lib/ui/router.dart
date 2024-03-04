import 'package:flutter_action_bank/ui/pages/debug.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Pages
import 'package:flutter_action_bank/ui/pages/start.dart';
import 'package:flutter_action_bank/ui/pages/home.dart';
import 'package:flutter_action_bank/ui/pages/login.dart';

import 'package:flutter_action_bank/global_state/authentication_provider.dart';

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
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (_, __) => DebugPage(),
    ),
  ],
);
