import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/nav.dart';

import 'package:flutter_vice_bank/ui/components/authentication_watcher.dart';
import 'package:provider/provider.dart';

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
    final padding = kIsWeb ? 25.0 : 0.0;

    print('kIsWeb: $kIsWeb');

    return Scaffold(
      appBar: appBar,
      body: AuthenticationWatcher(navigationShell),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: padding, top: 1),
        child: NavBar(navigationShell: navigationShell),
      ),
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

class DataWatcher extends StatefulWidget {
  @override
  State createState() => DataWatcherState();
}

class DataWatcherState extends State<DataWatcher> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    getDataAndResetTimer();
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, String?>(
      selector: (_, vbProvider) => vbProvider.currentUser?.id,
      builder: (_, userId, __) {
        if (userId == null) {
          _timer?.cancel();
          _timer = null;
        } else {
          getDataAndResetTimer();
        }

        return Container();
      },
    );
  }

  Future<void> getDataAndResetTimer() async {
    _timer?.cancel();
    await getApiData();
    resetTimer();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer(
      Duration(minutes: 10),
      getDataAndResetTimer,
    );
  }

  Future<void> getApiData() async {
    try {
      await Future.wait([
        getUserData(),
        getDataForUser(),
      ]);
    } catch (e) {
      LoggingProvider.instance.logError('Error getting data: $e');
    }
  }

  Future<void> getDataForUser() async {
    final vbProvider = context.read<ViceBankProvider>();
    if (vbProvider.currentUser == null) {
      return;
    }

    try {
      await Future.wait([
        vbProvider.getDepositConversions(),
        vbProvider.getDeposits(),
        vbProvider.getPurchasePrices(),
        vbProvider.getPurchases(),
      ]);
    } catch (e) {
      LoggingProvider.instance.logError('Error getting user data: $e');
    }
  }

  Future<void> getUserData() async {
    final vbProvider = context.read<ViceBankProvider>();
    try {
      await vbProvider.getViceBankUsers();
    } catch (e) {
      LoggingProvider.instance.logError('Error getting user data: $e');
    }
  }
}
