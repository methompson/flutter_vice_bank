import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/utils/delete_confirm.dart';

import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/utils/frequency.dart';

abstract class TDCard extends StatelessWidget {}

class TaskDepositCard extends TDCard {
  final TaskDeposit taskDeposit;

  TaskDepositCard({required this.taskDeposit});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("MM/dd/yyyy").format(taskDeposit.date.toLocal());
    final taskName = taskDeposit.taskName;
    final unit = taskDeposit.tokensEarned == 1 ? 'token' : 'tokens';
    final earned =
        'Earned ${taskDeposit.tokensEarned.toStringAsFixed(2)} $unit';

    return Card(
      child: ListTile(
        trailing: PopupMenuButton(
          icon: Icon(Icons.edit),
          onSelected: (String value) {
            if (value == 'edit') {
              // ea();
            } else if (value == 'delete') {
              deleteTaskDeposit(context);
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
            Text(taskName),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(earned),
          ],
        ),
      ),
    );
  }

  Future<void> deleteTaskDeposit(BuildContext context) async {
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
      await vbProvider.deleteTaskDeposit(taskDeposit);

      msgProvider.showSuccessSnackbar('Deposit Deleted');
    } catch (e) {
      msgProvider.showErrorSnackbar('Deleting Deposit Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}

class TaskCard extends TDCard {
  final Task task;
  final Function()? addAction;
  final Function()? editAction;

  TaskCard({
    required this.task,
    this.addAction,
    this.editAction,
  });

  @override
  Widget build(BuildContext context) {
    var frequency = 'Once a day';
    if (task.frequency == Frequency.weekly) {
      frequency = 'Once a week';
    } else if (task.frequency == Frequency.monthly) {
      frequency = 'Once a month';
    }

    frequency += ' for ${task.tokensPer} Token(s)';

    final ea = editAction;

    return Card(
      child: ListTile(
        title: Text(task.name),
        onTap: addAction,
        subtitle: Text(frequency),
        trailing: ea == null
            ? null
            : PopupMenuButton(
                icon: Icon(Icons.edit),
                onSelected: (String value) {
                  if (value == 'edit') {
                    ea();
                  } else if (value == 'delete') {
                    deleteTask(context);
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

  Future<void> deleteTask(BuildContext context) async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final result = await confirmDelete(
      context: context,
      title: 'Delete Task',
      content: 'Are you sure you want to delete this task?',
    );

    if (!result) {
      return;
    }

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Deleting Task...'),
    );

    try {
      await vbProvider.deleteTask(task);

      msgProvider.showSuccessSnackbar('Task Deleted');
    } catch (e) {
      msgProvider.showErrorSnackbar('Deleting Task Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
