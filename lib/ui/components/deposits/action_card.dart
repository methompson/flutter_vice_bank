import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:provider/provider.dart';

class ActionCard extends StatelessWidget {
  final VBAction action;
  final Function()? addAction;
  final Function()? editAction;

  ActionCard({required this.action, this.addAction, this.editAction});

  @override
  Widget build(BuildContext context) {
    final minDeposit = action.minDeposit;

    final minDepositWidget = minDeposit <= 0
        ? Container()
        : Text(
            'Min Deposit: $minDeposit ${action.conversionUnit}',
          );

    final depositTxt =
        '${action.depositsPer} ${action.conversionUnit} for ${action.tokensPer} Token(s)';

    final ea = editAction;

    return Card(
      child: ListTile(
        title: Text(
          action.name,
        ),
        onTap: addAction,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(depositTxt),
            minDepositWidget,
          ],
        ),
        trailing: ea == null
            ? null
            : PopupMenuButton(
                icon: Icon(Icons.edit),
                onSelected: (String value) {
                  if (value == 'edit') {
                    ea();
                  } else if (value == 'delete') {
                    deleteAction(context);
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ];
                },
              ),
      ),
    );
  }

  Future<bool> confirmDelete(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Action'),
          content: Text('Are you sure you want to delete this action?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  Future<void> deleteAction(BuildContext context) async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final result = await confirmDelete(context);

    if (!result) {
      return;
    }

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Deleting Action...'),
    );

    try {
      await vbProvider.deleteAction(action);

      msgProvider.showSuccessSnackbar('Action Deleted');
    } catch (e) {
      msgProvider.showErrorSnackbar('Deleting Action Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
