import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/ui/components/nav.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_vice_bank/ui/components/authentication_watcher.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  PageContainer({
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: child,
    );
  }
}

class NavContainer extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final PreferredSizeWidget? appBar;

  NavContainer({
    required this.navigationShell,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: AuthenticationWatcher(navigationShell),
      bottomNavigationBar: NavBar(navigationShell: navigationShell),
    );
  }
}

class FullSizeContainer extends StatelessWidget {
  final Widget child;

  FullSizeContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.greenAccent,
      constraints: BoxConstraints.expand(),
      child: child,
    );
  }
}

class CenteredFullSizeContainer extends StatelessWidget {
  final Widget child;

  CenteredFullSizeContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blueAccent,
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: child),
        ],
      ),
    );
  }
}
