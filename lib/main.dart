import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/global_state/authentication_provider.dart';
import 'package:flutter_vice_bank/global_state/config_provider.dart';
import 'package:flutter_vice_bank/global_state/data_provider.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MessagingProvider.instance),
        ChangeNotifierProvider.value(value: ConfigProvider.instance),
        ChangeNotifierProvider.value(value: LoggingProvider.instance),
        ChangeNotifierProvider.value(value: DataProvider.instance),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => ViceBankProvider()),
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
    final vbProvider = context.read<ViceBankProvider>();

    await DataProvider.instance.init();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final currentUser = FirebaseAuth.instance.currentUser;

    authProvider.setAuthentication(currentUser);

    await ConfigProvider.instance.init();

    await LoggingProvider.instance.init();

    if (currentUser != null) {
      await vbProvider.init();
    }
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
