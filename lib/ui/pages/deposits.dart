import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';

import 'package:flutter_vice_bank/ui/components/abstract_vbuser_data_watcher.dart';
import 'package:flutter_vice_bank/ui/components/deposits/deposit_content.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';
import 'package:flutter_vice_bank/ui/components/users/no_user_selected.dart';

class DepositsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, ViceBankUser?>(
      selector: (_, vbProvider) => vbProvider.currentUser,
      builder: (context, user, _) {
        final content = user == null ? NoUserSelected() : DepositsContent();

        return Stack(
          children: [
            DepositDataWatcher(),
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

class DepositDataWatcher extends StatefulWidget {
  @override
  State createState() => DepositDataWatcherState();
}

class DepositDataWatcherState extends VBUserDataWatcher {
  @override
  Future<void> getApiData() async {
    try {
      final vbProvider = context.read<ViceBankProvider>();

      await Future.wait([
        vbProvider.getDepositConversions(),
        vbProvider.getDeposits(),
      ]);
    } catch (e) {
      // TODO log this data
    }
  }
}
