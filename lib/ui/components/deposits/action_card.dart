import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/action.dart';

class ActionCard extends StatelessWidget {
  final VBAction action;
  final Function()? onTap;

  ActionCard({required this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    final minDeposit = action.minDeposit;

    final minDepositWidget = minDeposit <= 0
        ? Container()
        : Text('Min Deposit: $minDeposit ${action.conversionUnit}');

    final depositTxt =
        '${action.depositsPer} ${action.conversionUnit} for ${action.tokensPer} Token(s)';

    return Card(
      child: ListTile(
        title: Text(action.name),
        onTap: onTap,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(depositTxt),
            minDepositWidget,
          ],
        ),
      ),
    );
  }
}
