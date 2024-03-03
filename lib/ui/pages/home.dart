import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_action_bank/ui/components/page_container.dart';

class HomePage extends StatelessWidget {
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
