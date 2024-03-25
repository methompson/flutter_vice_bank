import 'package:debouncer_widget/debouncer_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/global_state/config_provider.dart';

class CopyrightBar extends StatefulWidget {
  CopyrightBar({super.key});

  @override
  State createState() => CopyrightBarState();
}

class CopyrightBarState extends State<CopyrightBar> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
  );

  int taps = 0;

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().year;
    final config = ConfigProvider.instance;
    final debugMode = config.getConfig('debugMode').boolean;

    final bgColor =
        debugMode ? Colors.blueAccent : Theme.of(context).colorScheme.primary;

    final txtColor = Theme.of(context).colorScheme.onPrimary;

    final versionInfo =
        'Version: ${_packageInfo.version} Build: ${_packageInfo.buildNumber}';

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
            color: bgColor,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '© $today Mat Thompson',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: txtColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  versionInfo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: txtColor,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  resetKey() {
    setState(() {
      taps = 0;
    });
  }
}
