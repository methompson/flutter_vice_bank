import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Home Page'),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: BasicBigTextButton(
            onPressed: logUserOut,
            text: 'Logout',
          ),
        ),
      ],
    );
  }

  logUserOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
