import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';

import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/utils/frequency.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
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

  Future<bool> confirmDelete(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
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

  Future<void> deleteTask(BuildContext context) async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final result = await confirmDelete(context);

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
