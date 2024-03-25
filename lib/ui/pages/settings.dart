import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/global_state/authentication_provider.dart';
import 'package:flutter_vice_bank/global_state/config_provider.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';

import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/debug_buttons.dart';
import 'package:flutter_vice_bank/ui/components/theme_colors.dart';
import 'package:flutter_vice_bank/ui/components/user_header.dart';
import 'package:flutter_vice_bank/ui/components/users/no_user_selected.dart';
import 'package:flutter_vice_bank/ui/pages/login.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: SettingsContent(),
          ),
        ),
        Selector<ConfigProvider, bool>(
          selector: (_, config) => config.getConfig('debugMode').boolean,
          builder: (_, __, ___) {
            return CopyrightBar();
          },
        ),
      ],
    );
  }
}

class CommonMargin extends StatelessWidget {
  final Widget child;

  const CommonMargin(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }
}

class SettingsSelectAUserButton extends SelectAUserButton {
  @override
  Widget build(BuildContext context) {
    return CommonMargin(BasicBigTextButton(
      onPressed: () => openSelectUserDialog(context),
      text: 'Select a User',
      topMargin: 10,
      bottomMargin: 10,
    ));
  }
}

class SettingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigProvider>();
    final debugMode = config.getConfig('debugMode').boolean;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserHeader(),
        CommonMargin(Text(
          'Settings Page',
          style: Theme.of(context).copyWith().textTheme.headlineMedium,
        )),
        CommonMargin(BasicBigTextButton(
          onPressed: () => clearCache(context),
          text: 'Clear Cache',
          topMargin: 10,
          bottomMargin: 10,
        )),
        SettingsSelectAUserButton(),
        CommonMargin(BasicBigTextButton(
          onPressed: () => context.push('/settings/logging'),
          text: 'Logging',
          topMargin: 10,
          bottomMargin: 10,
        )),
        CommonMargin(BasicBigTextButton(
          onPressed: () => logUserOut(context),
          text: 'Logout',
          topMargin: 10,
          bottomMargin: 10,
        )),
        if (debugMode) ...debugWidgets(context),
      ],
    );
  }

  List<Widget> debugWidgets(BuildContext context) {
    return [
      Divider(),
      CommonMargin(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Debug Buttons',
            style: Theme.of(context).copyWith().textTheme.headlineMedium,
          ),
          DebugButtons(),
        ],
      )),
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
