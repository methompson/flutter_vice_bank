import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_action_bank/ui/components/authentication_watcher.dart';

class PageContainer extends StatelessWidget {
  final Widget child;

  PageContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}

class NavContainer extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  NavContainer({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthenticationWatcher(navigationShell),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Debug',
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(index),
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
