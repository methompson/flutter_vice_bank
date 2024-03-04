import 'package:flutter/widgets.dart';
import 'package:flutter_action_bank/ui/components/loading_screen.dart';

class Loadable extends StatelessWidget {
  final Widget child;

  Loadable(this.child);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        LoadingScreen(),
      ],
    );
  }
}
