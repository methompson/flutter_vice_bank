import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';

class DepositCard extends StatelessWidget {
  final Deposit deposit;

  DepositCard({required this.deposit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(deposit.depositConversionName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${deposit.depositQuantity} ${deposit.conversionUnit}'),
            Text('Earned ${deposit.tokensEarned.toStringAsFixed(2)} tokens'),
          ],
        ),
      ),
    );
  }
}
