import 'package:debouncer_widget/debouncer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/global_state/config_provider.dart';
import 'package:flutter_vice_bank/ui/components/login/debug_section.dart';
import 'package:flutter_vice_bank/ui/components/login/login_fields.dart';

import 'package:flutter_vice_bank/ui/components/messenger.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ConfigProvider, bool>(
      selector: (_, config) => config.getConfig('debugMode').boolean,
      builder: (context, debugMode, child) {
        return PageContainer(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          child: LoginFields(),
                        ),
                      ),
                    ),
                  ),
                ),
                if (debugMode) LoginDebugSection(),
                CopyrightBar(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Messenger(Login());
  }
}

class CopyrightBar extends StatefulWidget {
  CopyrightBar({super.key});

  @override
  State createState() => CopyrightBarState();
}

class CopyrightBarState extends State<CopyrightBar> {
  int taps = 0;
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().year;
    final config = ConfigProvider.instance;
    final debugMode = config.getConfig('debugMode').boolean;

    final color =
        debugMode ? Colors.blueAccent : Theme.of(context).colorScheme.primary;

    return Debouncer(
      action: resetKey,
      timeout: Duration(seconds: 10),
      builder: (context, __) {
        return GestureDetector(
          onTap: () {
            taps++;
            if (taps > 10) {
              config.setConfig('debugMode', true);
            }
            Debouncer.execute(context);
          },
          child: Container(
            color: color,
            padding: EdgeInsets.all(20),
            child: Text(
              '© $today Mat Thompson',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  resetKey() {
    setState(() {
      taps = 0;
    });
  }
}
