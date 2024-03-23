import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:intl/intl.dart';

class TaskDepositCard extends StatelessWidget {
  final TaskDeposit taskDeposit;

  TaskDepositCard({required this.taskDeposit});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("MM/dd/yyyy").format(taskDeposit.date);
    final taskName = taskDeposit.taskName;
    final unit = taskDeposit.tokensEarned == 1 ? 'token' : 'tokens';
    final earned =
        'Earned ${taskDeposit.tokensEarned.toStringAsFixed(2)} $unit';

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
}
