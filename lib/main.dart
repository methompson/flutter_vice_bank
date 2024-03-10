import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/global_state/authentication_provider.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/ui/components/bootstrapper.dart';
import 'package:flutter_vice_bank/ui/router.dart';

import 'package:flutter_vice_bank/firebase_options.dart';
import 'package:flutter_vice_bank/ui/theme.dart';

void main() {
  runApp(ProvidersContainer());
}

class ProvidersContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return _BootStrap();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider.value(value: MessagingProvider.instance),
        ChangeNotifierProvider(create: (_) => ViceBankProvider())
      ],
      child: _BootStrap(),
    );
  }
}

class _BootStrap extends StatelessWidget {
  @override
  build(BuildContext context) {
    return BootStrapper(
      app: TheApp(),
      initFunction: initializeApp,
    );
  }

  Future<void> initializeApp(BuildContext context) async {
    final authProvider = context.read<AuthenticationProvider>();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    authProvider.setAuthentication(FirebaseAuth.instance.currentUser);
  }
}

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: snackbarMessengerKey,
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
