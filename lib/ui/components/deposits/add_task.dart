import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/deposits/task_card.dart';
import 'package:provider/provider.dart';

class AddTaskForm extends StatefulWidget {
  final Task task;

  AddTaskForm({required this.task});

  @override
  State<AddTaskForm> createState() => AddTaskFormState();
}

class AddTaskFormState extends State<AddTaskForm> {
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
