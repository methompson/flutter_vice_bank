import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:intl/intl.dart';

class DepositCard extends StatelessWidget {
  final Deposit deposit;

  DepositCard({required this.deposit});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("MM/dd/yyyy").format(deposit.date);
    final actionName = deposit.actionName;
    final depositQuantity =
        '${deposit.depositQuantity} ${deposit.conversionUnit}';

    final unit = deposit.tokensEarned == 1 ? 'token' : 'tokens';
    final tokensEarned =
        'Earned ${deposit.tokensEarned.toStringAsFixed(2)} $unit';

    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 11,
                  ),
            ),
            Text(actionName),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(depositQuantity),
            Text(tokensEarned),
          ],
        ),
      ),
    );
  }
}
