import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/global_state/config_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';

class LoginDebugSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BasicBigTextButton(
            onPressed: turnOffDebugMode,
            text: 'Turn off debug mode',
            topMargin: 10,
            bottomMargin: 10,
          ),
        ],
      ),
    );
  }

  void turnOffDebugMode() {
    final config = ConfigProvider.instance;

    config.setConfig('debugMode', false);
  }
}
