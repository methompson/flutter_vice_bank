import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/utils/frequency.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function()? onTap;

  TaskCard({required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    var frequency = 'Once a day';
    if (task.frequency == Frequency.weekly) {
      frequency = 'Once a week';
    } else if (task.frequency == Frequency.monthly) {
      frequency = 'Once a month';
    }

    frequency += ' for ${task.tokensPer} Token(s)';

    return Card(
      child: ListTile(
        title: Text(task.name),
        onTap: onTap,
        subtitle: Text(frequency),
      ),
    );
  }
}
