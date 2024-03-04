import 'package:flutter/cupertino.dart';
import 'package:flutter_action_bank/data_models/messaging_data.dart';
import 'package:provider/provider.dart';

import 'package:flutter_action_bank/global_state/messaging_provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<MessagingProvider, LoadingScreenData?>(
      selector: (_, provider) => provider.loadingScreenData,
      builder: (_, loadingScreenData, __) {
        final ignoring = loadingScreenData == null;

        final child =
            loadingScreenData != null ? LoadingScreenWidgets() : Container();

        return IgnorePointer(
          ignoring: ignoring,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: child,
          ),
        );
      },
    );
  }
}

class LoadingScreenWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO get loading screen data from messaging provider
    final msgProvider = context.read<MessagingProvider>();

    final msg = msgProvider.loadingScreenData?.message ?? 'Loading...';
    final onCancel = msgProvider.loadingScreenData?.onCancel;

    return Container(
      color: CupertinoColors.black.withOpacity(0.7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CupertinoActivityIndicator(
              radius: 20,
              color: CupertinoColors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              msg,
              style: TextStyle(
                color: CupertinoColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (onCancel != null)
            CupertinoButton.filled(
              onPressed: onCancel,
              child: Text('Cancel'),
            )
        ],
      ),
    );
  }
}

class Loadable extends StatelessWidget {
  final Widget child;

  Loadable(this.child);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        LoadingScreen(),
      ],
    );
  }
}
