import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:intl/intl.dart';

class TaskDepositCard extends StatelessWidget {
  final TaskDeposit taskDeposit;

  TaskDepositCard({required this.taskDeposit});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("MM/dd/yyyy").format(taskDeposit.date);
    final unit = taskDeposit.tokensEarned == 1 ? 'token' : 'tokens';

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
              taskDeposit.taskName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Earned ${taskDeposit.tokensEarned.toStringAsFixed(2)} $unit',
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
