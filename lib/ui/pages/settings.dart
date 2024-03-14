import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/global_state/authentication_provider.dart';
import 'package:flutter_vice_bank/global_state/config_provider.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';

import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/debug_buttons.dart';
import 'package:flutter_vice_bank/ui/components/theme_colors.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: SettingsContent(),
          ),
        ),
      ],
    );
  }
}

class SettingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigProvider>();
    final debugMode = config.getConfig('debugMode').boolean;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text(
          //   'Settings Page',
          //   style: Theme.of(context).copyWith().textTheme.bodyLarge,
          // ),
          BasicBigTextButton(
            onPressed: () => clearCache(context),
            text: 'Clear Cache',
            topMargin: 10,
            bottomMargin: 10,
          ),
          BasicBigTextButton(
            onPressed: () => logUserOut(context),
            text: 'Logout',
            topMargin: 10,
            bottomMargin: 10,
          ),
          if (debugMode) ...debugWidgets(context),
        ],
      ),
    );
  }

  List<Widget> debugWidgets(BuildContext context) {
    return [
      Divider(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Debug Buttons',
            style: Theme.of(context).copyWith().textTheme.bodyLarge,
          ),
          DebugButtons(),
        ],
      ),
      ThemeColors(),
    ];
  }

  Future<void> clearCache(BuildContext context) async {
    final vbProvider = context.read<ViceBankProvider>();
    final msgProvider = context.read<MessagingProvider>();

    try {
      await vbProvider.clearCache();
      await vbProvider.getViceBankUsers();
    } catch (e) {
      msgProvider.showErrorSnackbar(e.toString());
    }
  }

  logUserOut(BuildContext context) async {
    final authProvider = context.read<AuthenticationProvider>();
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    try {
      await authProvider.signOut();
      await vbProvider.clearCache();
    } catch (e) {
      msgProvider.showErrorSnackbar(e.toString());
    }
  }
}
