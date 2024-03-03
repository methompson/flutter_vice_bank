import 'package:flutter/cupertino.dart';

class PageContainer extends StatelessWidget {
  final Widget child;

  PageContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: child,
    );
  }
}
