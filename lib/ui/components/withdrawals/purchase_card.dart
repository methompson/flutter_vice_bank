import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/utils/delete_confirm.dart';

class PurchaseCard extends StatelessWidget {
  final Purchase purchase;

  PurchaseCard({required this.purchase});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("MM/dd/yyyy").format(purchase.date);
    final name = purchase.purchasedName;

    // final purchasePrice = purchase.

    final unit = purchase.tokensSpent == 1 ? 'token' : 'tokens';
    final quantity = 'Spent ${purchase.tokensSpent} $unit';

    return Card(
      child: ListTile(
        trailing: PopupMenuButton(
          icon: Icon(Icons.edit),
          onSelected: (String value) {
            if (value == 'edit') {
              // ea();
            } else if (value == 'delete') {
              deletePurchase(context);
            }
          },
          itemBuilder: (context) {
            return [
              // PopupMenuItem(
              //   value: 'edit',
              //   child: Text('Edit'),
              // ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ];
          },
        ),
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

  Future<void> deletePurchase(BuildContext context) async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final result = await confirmDelete(
      context: context,
      title: 'Delete Purchase',
      content: 'Are you sure you want to delete this purchase?',
    );

    if (!result) {
      return;
    }

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Deleting Purchase...'),
    );

    try {
      await vbProvider.deletePurchase(purchase);

      msgProvider.showSuccessSnackbar('Purchase Deleted');
    } catch (e) {
      msgProvider.showErrorSnackbar('Deleting Purchase Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
