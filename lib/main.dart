import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_action_bank/global_state/authentication_provider.dart';

import 'package:flutter_action_bank/ui/components/bootstrapper.dart';
import 'package:flutter_action_bank/ui/router.dart';

import 'package:flutter_action_bank/firebase_options.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Action Bank',
      home: ProvidersContainer(),
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemRed,
      ),
    );
  }
}

class ProvidersContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return _BootStrap();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
      ],
      child: AuthInitContainer(),
    );
  }
}

class AuthInitContainer extends StatefulWidget {
  @override
  State<AuthInitContainer> createState() => _AuthInitContainerState();
}

class _AuthInitContainerState extends State<AuthInitContainer> {
  @override
  initState() {
    super.initState();
    appInit();
  }

  appInit() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('Firebase initialized');

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      final authProvider = context.read<AuthenticationProvider>();
      authProvider.setAuthentication(user);

      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        print(user.displayName);
        print(user.email);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _BootStrap();
  }
}

class _BootStrap extends StatelessWidget {
  @override
  build(BuildContext context) {
    return BootStrapper(
      app: CupertinoApp.router(
        routerConfig: router,
      ),
      initFunction: () async {},
    );
  }
}
