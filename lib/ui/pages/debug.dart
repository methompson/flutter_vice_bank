import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_action_bank/data_models/messaging_data.dart';
import 'package:flutter_action_bank/global_state/messaging_provider.dart';
import 'package:flutter_action_bank/ui/components/authentication_watcher.dart';
import 'package:flutter_action_bank/ui/components/loadable.dart';
import 'package:flutter_action_bank/ui/components/page_container.dart';
import 'package:provider/provider.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthenticationWatcher(Loadable(Debug()));
  }
}

class Debug extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ShowLoadingScreenWithCancelButton(),
          _ShowLoadingScreenWithAutoClose()
        ],
      ),
    );
  }
}

class DebugButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function() onPressed;

  DebugButton({
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: CupertinoButton.filled(
        onPressed: onPressed,
        child: Text(buttonText),
      ),
    );
  }
}

class _ShowLoadingScreenWithCancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Show Loading Screen with Cancel Button',
      onPressed: () {
        final msgProvider = context.read<MessagingProvider>();
        msgProvider.setLoadingScreenData(
          LoadingScreenData(
            message: 'Loading...',
            onCancel: () {
              msgProvider.clearLoadingScreen();
            },
          ),
        );
      },
    );
  }
}

class _ShowLoadingScreenWithAutoClose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Show Loading Screen with Auto Close',
      onPressed: () {
        final msgProvider = context.read<MessagingProvider>();
        msgProvider.setLoadingScreenData(
          LoadingScreenData(
            message: 'Loading...',
          ),
        );

        Timer(Duration(seconds: 3), () {
          msgProvider.clearLoadingScreen();
        });
      },
    );
  }
}
