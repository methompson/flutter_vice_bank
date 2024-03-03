import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
      builder: (_, __) => AuthenticationWatcher(HomePage()),
    ),
  ],
);

class AuthenticationWatcher extends StatefulWidget {
  final Widget child;

  AuthenticationWatcher(this.child);

  @override
  State<AuthenticationWatcher> createState() => AuthenticationWatcherState();
}

class AuthenticationWatcherState extends State<AuthenticationWatcher> {
  StreamSubscription? authStreamListener;

  @override
  initState() {
    super.initState();
    authInit();
  }

  @override
  dispose() {
    print('disposing');
    super.dispose();
    authStreamListener?.cancel();
  }

  authInit() {
    print('authInit');
    authStreamListener =
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      final authProvider = context.read<AuthenticationProvider>();
      authProvider.setAuthentication(user);

      if (user == null) {
        print('User is currently signed out!');

        context.go('/login');
      } else {
        print('User is signed in!');
        print(user.displayName);
        print(user.email);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
