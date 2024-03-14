import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:intl/intl.dart';

class DepositCard extends StatelessWidget {
  final Deposit deposit;

  DepositCard({required this.deposit});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("MM/dd/yyyy").format(deposit.date);
    final unit = deposit.tokensEarned == 1 ? 'token' : 'tokens';

    return Card(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 11,
                  ),
            ),
            Text(
              deposit.depositConversionName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${deposit.depositQuantity} ${deposit.conversionUnit}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            Text(
              'Earned ${deposit.tokensEarned.toStringAsFixed(2)} $unit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
