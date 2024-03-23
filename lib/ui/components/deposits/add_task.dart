import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/deposits/task_card.dart';
import 'package:flutter_vice_bank/utils/frequency.dart';

class AddTaskForm extends StatefulWidget {
  @override
  State<AddTaskForm> createState() => AddTaskFormState();
}

class AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController tokensPerController = TextEditingController();

  get nameIsValid => nameController.text.isNotEmpty;

  get tokensPerIsValid {
    final parsedValue = num.tryParse(tokensPerController.text);
    return parsedValue != null && parsedValue > 0;
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalMargin = 20;
    const double verticalMargin = 10;

    final canDeposit = nameIsValid && nameIsValid && tokensPerIsValid;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: TextField(
              onChanged: (_) => setState(() {}),
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Name',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: TextField(
              controller: tokensPerController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Tokens Per (How many tokens you get for the rate)',
              ),
            ),
          ),
          BasicBigTextButton(
            text: 'Add New Task',
            allMargin: 10,
            topPadding: 10,
            bottomPadding: 10,
            disabled: !canDeposit,
            onPressed: addNewTask,
          ),
          BasicBigTextButton(
            text: 'Cancel',
            allMargin: 10,
            topPadding: 10,
            bottomPadding: 10,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> addNewTask() async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final currentUser = vbProvider.currentUser;

    if (currentUser == null) {
      msgProvider.showErrorSnackbar(
          'No user selected. Select a Vice Bank User First.');
      return;
    }

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Adding Task...'),
    );

    try {
      final userId = currentUser.id;
      final name = nameController.text;
      final tokensPer = num.parse(tokensPerController.text);

      final newTask = Task.newTask(
        vbUserId: userId,
        name: name.trim(),
        frequency: Frequency.daily,
        tokensPer: tokensPer,
      );

      await vbProvider.createTask(newTask);

      msgProvider.showSuccessSnackbar('Task added');

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Adding Task Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}

class AddTaskFormOld extends StatefulWidget {
  final Task task;

  AddTaskFormOld({required this.task});

  @override
  State<AddTaskFormOld> createState() => AddTaskFormOldState();
}

class AddTaskFormOldState extends State<AddTaskFormOld> {
  @override
  Widget build(BuildContext context) {
    const double verticalMargin = 10;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: verticalMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TaskCard(task: widget.task),
            BasicBigTextButton(
              text: 'Deposit',
              topMargin: 10,
              topPadding: 10,
              bottomPadding: 10,
              onPressed: addDeposit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addDeposit() async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Adding Deposit...'),
    );

    try {
      final depositToAdd = TaskDeposit.newTaskDeposit(
        vbUserId: widget.task.vbUserId,
        task: widget.task,
      );

      await vbProvider.addTaskDeposit(depositToAdd);

      msgProvider.showSuccessSnackbar('Deposit Added');

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Adding Deposit Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
