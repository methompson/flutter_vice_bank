import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';

import 'package:flutter_vice_bank/ui/components/deposits/deposit_content.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';
import 'package:flutter_vice_bank/ui/components/users/no_user_selected.dart';

class DepositsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, ViceBankUser?>(
      selector: (_, vbProvider) => vbProvider.currentUser,
      builder: (context, currentUser, _) {
        final child =
            currentUser == null ? NoUserSelected() : DepositsContent();

        return CenteredFullSizeContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Expanded(child: child)],
          ),
        );
      },
    );
  }
}
