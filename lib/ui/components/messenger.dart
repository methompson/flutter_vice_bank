import 'package:flutter/material.dart';
import 'package:flutter_action_bank/ui/components/loading_screen.dart';

class Messenger extends StatelessWidget {
  final Widget child;

  Messenger(this.child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          LoadingScreen(),
        ],
      ),
    );
  }
}
