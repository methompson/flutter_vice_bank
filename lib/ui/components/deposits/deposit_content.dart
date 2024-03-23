import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:flutter_vice_bank/ui/components/deposits/add_task.dart';
import 'package:flutter_vice_bank/ui/components/deposits/task_card.dart';
import 'package:flutter_vice_bank/ui/components/deposits/task_deposit_card.dart';
import 'package:flutter_vice_bank/ui/components/user_header.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';

import 'package:flutter_vice_bank/ui/components/deposits/add_action.dart';
import 'package:flutter_vice_bank/ui/components/deposits/add_deposit.dart';
import 'package:flutter_vice_bank/ui/components/deposits/deposit_card.dart';
import 'package:flutter_vice_bank/ui/components/deposits/action_card.dart';
import 'package:flutter_vice_bank/ui/components/title_widget.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';

class DepositsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserHeader(),
        Expanded(
          child: DepositsDataContent(),
        ),
      ],
    );
  }
}

class DepositsDataContent extends StatelessWidget {
  @override
  Widget build(BuildContext _) {
    return Selector<
        ViceBankProvider,
        ({
          List<VBAction> actions,
          List<Task> tasks,
        })>(
      selector: (_, vb) => (
        actions: vb.actions,
        tasks: vb.tasks,
      ),
      builder: (_, data, __) {
        return Selector<
            ViceBankProvider,
            ({
              List<Deposit> deposits,
              List<TaskDeposit> taskDeposits,
            })>(
          selector: (context, vb) => (
            deposits: vb.deposits,
            taskDeposits: vb.taskDeposits,
          ),
          builder: (context, depositData, __) {
            final items = [
              ...actionWidgets(
                context,
                data.actions,
                data.tasks,
              ),
              ...depositHistoryWidgets(
                context,
                depositData.deposits,
                depositData.taskDeposits,
              ),
            ];

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return items[index];
                },
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> actionWidgets(
    BuildContext context,
    List<VBAction> conversions,
    List<Task> tasks,
  ) {
    List<dynamic> list = [
      ...conversions,
      ...tasks,
    ];

    list.sort((a, b) {
      final aname = a is VBAction || a is Task ? a.name : 'ZZZZZZZZZZZ';
      final bname = b is VBAction || b is Task ? b.name : 'ZZZZZZZZZZZ';

      return aname.compareTo(bname);
    });

    if (list.isEmpty) {
      return [
        TitleWidget(title: 'No Tasks or Actions'),
        AddActionButton(),
      ];
    }

    final List<Widget> conversionWidgets = list.map((val) {
      if (val is VBAction) {
        return ActionCard(
          action: val,
          onTap: () => openAddDepositDialog(
            context: context,
            action: val,
          ),
        );
      } else if (val is Task) {
        return TaskCard(
          task: val,
          onTap: () => openAddTaskDialog(
            context: context,
            task: val,
          ),
        );
      } else {
        return Container();
      }
    }).toList();

    return [
      TitleWithIconButton(
        title: 'Actions and Tasks',
        iconButton: AddActionIconButton(),
      ),
      ...conversionWidgets,
    ];
  }

  List<Widget> depositHistoryWidgets(
    BuildContext context,
    List<Deposit> deposits,
    List<TaskDeposit> taskDeposits,
  ) {
    List<dynamic> list = [
      ...deposits,
      ...taskDeposits,
    ];

    list.sort((a, b) {
      final adate = a is VBAction || a is Task ? a.date : DateTime(0);
      final bdate = b is VBAction || b is Task ? b.date : DateTime(0);

      return adate.compareTo(bdate);
    });

    final List<Widget> depositWidgets = list.map((val) {
      if (val is Deposit) {
        return DepositCard(deposit: val);
      } else if (val is TaskDeposit) {
        return TaskDepositCard(taskDeposit: val);
      } else {
        return Container();
      }
    }).toList();

    // final List<Widget> depositWidgets = deposits.map((deposit) {
    //   return DepositCard(deposit: deposit);
    // }).toList();

    return [
      TitleWidget(title: 'Deposit History'),
      ...depositWidgets,
    ];
  }

  void openAddDepositDialog({
    required BuildContext context,
    required VBAction action,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(
          body: FullSizeContainer(
            child: AddDepositForm(
              action: action,
            ),
          ),
        );
      },
    );
  }

  void openAddTaskDialog({
    required BuildContext context,
    required Task task,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(
          body: FullSizeContainer(
            child: AddTaskFormOld(task: task),
          ),
        );
      },
    );
  }
}

abstract class AbstractAddActionButton extends StatelessWidget {
  void openAddActionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(
          body: FullSizeContainer(
            child: AddActionTaskForm(),
          ),
        );
      },
    );
  }
}

class AddActionIconButton extends AbstractAddActionButton {
  @override
  Widget build(BuildContext context) {
    return AddIconButton(onPressed: openAddActionDialog);
  }
}

class AddActionButton extends AbstractAddActionButton {
  @override
  Widget build(BuildContext context) {
    return BasicBigTextButton(
      topMargin: 20,
      bottomMargin: 10,
      allPadding: 10,
      text: 'Add an Action or Task',
      onPressed: () {
        openAddActionDialog(context);
      },
    );
  }
}

class AddActionTaskForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Action or Task'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Action'),
              Tab(text: 'Task'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddActionForm(),
            AddTaskForm(),
          ],
        ),
      ),
    );
    // return Column(
    //   children: [
    //     TabBar(
    //       tabs: [
    //         Tab(text: 'Actions'),
    //         Tab(text: 'Tasks'),
    //       ],
    //     ),
    //     TabBarView(
    //       children: [
    //         AddActionForm(),
    //         AddTaskForm(),
    //       ],
    //     ),
    //   ],
    // );
  }
}
