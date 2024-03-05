import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_action_bank/data_models/messaging_data.dart';
import 'package:flutter_action_bank/global_state/messaging_provider.dart';
import 'package:flutter_action_bank/ui/components/buttons.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ShowLoadingScreenWithCancelButton(),
        _ShowLoadingScreenWithAutoClose(),
        _ShowSnackBarMessage(),
      ],
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
      child: BasicTextButton(
        onPressed: onPressed,
        text: buttonText,
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
      buttonText: 'Show Loading Screen with Fast Auto Close',
      onPressed: () {
        final msgProvider = context.read<MessagingProvider>();
        msgProvider.setLoadingScreenData(
          LoadingScreenData(
            message: 'Loading...',
          ),
        );

        Timer(Duration(milliseconds: 100), () {
          msgProvider.clearLoadingScreen();
        });
      },
    );
  }
}

class _ShowSnackBarMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Show Snack Bar Message',
      onPressed: () {
        context.read<MessagingProvider>().showErrorSnackbar('Error Message');
      },
    );
  }
}
