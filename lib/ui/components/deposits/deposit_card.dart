import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/utils/delete_confirm.dart';

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
        trailing: PopupMenuButton(
          icon: Icon(Icons.edit),
          onSelected: (String value) {
            if (value == 'edit') {
              // ea();
            } else if (value == 'delete') {
              deleteDeposit(context);
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

  Future<void> deleteDeposit(BuildContext context) async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final result = await confirmDelete(
      context: context,
      title: 'Delete Deposit',
      content: 'Are you sure you want to delete this deposit?',
    );

    if (!result) {
      return;
    }

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Deleting Deposit...'),
    );

    try {
      await vbProvider.deleteDeposit(deposit);

      msgProvider.showSuccessSnackbar('Deposit Deleted');
    } catch (e) {
      msgProvider.showErrorSnackbar('Deleting Deposit Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
