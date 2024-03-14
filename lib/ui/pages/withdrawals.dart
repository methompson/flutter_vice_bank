import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/abstract_vbuser_data_watcher.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';
import 'package:flutter_vice_bank/ui/components/users/no_user_selected.dart';
import 'package:flutter_vice_bank/ui/components/withdrawals/withdrawal_content.dart';

class WithdrawalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, ViceBankUser?>(
      selector: (_, vbProvider) => vbProvider.currentUser,
      builder: (context, user, _) {
        final content = user == null ? NoUserSelected() : WithDrawalContent();

        return Stack(
          children: [
            WithdrawalDataWatcher(),
            CenteredFullSizeContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [Expanded(child: content)],
              ),
            ),
          ],
        );
      },
    );
  }
}

class WithdrawalDataWatcher extends StatefulWidget {
  @override
  State createState() => WithdrawalDataWatcherState();
}

class WithdrawalDataWatcherState extends VBUserDataWatcher {
  @override
  Future<void> getApiData() async {
    try {
      final vbProvider = context.read<ViceBankProvider>();

      await Future.wait([
        vbProvider.getPurchasePrices(),
        vbProvider.getPurchases(),
      ]);
    } catch (e) {
      LoggingProvider.instance.logError('Error getting withdrawal data: $e');
    }
  }
}
