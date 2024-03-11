import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_vice_bank/global_state/authentication_provider.dart';

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
    super.dispose();
    authStreamListener?.cancel();
  }

  authInit() {
    authStreamListener =
        FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      final authProvider = context.read<AuthenticationProvider>();
      authProvider.setAuthentication(user);

      if (user == null) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
