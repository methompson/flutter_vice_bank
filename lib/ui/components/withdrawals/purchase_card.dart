import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_vice_bank/data_models/purchase.dart';

class PurchaseCard extends StatelessWidget {
  final Purchase purchase;

  PurchaseCard({required this.purchase});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("MM/dd/yyyy").format(purchase.date);
    final name = purchase.purchasedName;

    final unit = purchase.purchasedQuantity == 1 ? 'token' : 'tokens';
    final quantity = 'Spent ${purchase.purchasedQuantity} $unit';

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
            Text(name),
          ],
        ),
        subtitle: Text(quantity),
      ),
    );
  }
}
