import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_action_bank/ui/components/authentication_watcher.dart';
import 'package:flutter_action_bank/ui/components/loadable.dart';

import 'package:flutter_action_bank/ui/components/page_container.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('home page');
    return PageContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Home Page'),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: CupertinoButton.filled(
              onPressed: logUserOut,
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }

  logUserOut() async {
    await FirebaseAuth.instance.signOut();
    print('Logged out');
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationWatcher(Loadable(Home()));
  }
}
