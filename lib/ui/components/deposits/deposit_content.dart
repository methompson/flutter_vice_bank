import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/ui/components/deposits/add_task.dart';
import 'package:flutter_vice_bank/ui/components/deposits/add_task_deposit.dart';
import 'package:flutter_vice_bank/ui/components/deposits/task_deposit_card.dart';
import 'package:flutter_vice_bank/ui/components/user_header.dart';
import 'package:intl/intl.dart';
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

void openAddActionTaskDialog(
  BuildContext context, {
  VBAction? action,
  Task? task,
}) {
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
          child: AddActionTaskForm(
            action: action,
            task: task,
          ),
        ),
      );
    },
  );
}

class DepositsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserHeader(),
        Expanded(
          child: _DepositsDataContent(),
        ),
      ],
    );
  }
}

class _DepositsDataContent extends StatefulWidget {
  @override
  _DepositsDataContentState createState() => _DepositsDataContentState();
}

class _DepositsDataContentState extends State<_DepositsDataContent> {
  List<bool> _isOpen = [];

  @override
  Widget build(BuildContext context) {
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
          addAction: () => openAddDepositDialog(
            context: context,
            action: val,
          ),
          editAction: () {
            openAddActionTaskDialog(
              context,
              action: val,
            );
          },
        );
      } else if (val is Task) {
        return TaskCard(
          task: val,
          addAction: () => openAddTaskDialog(
            context: context,
            task: val,
          ),
          editAction: () {
            openAddActionTaskDialog(
              context,
              task: val,
            );
          },
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
    Map<String, List<TD>> dMap = {};

    for (final d in deposits) {
      final date = DateFormat("MM/dd/yyyy").format(d.date.toLocal());
      final td = dMap[date] ?? [];
      td.add(d);
      dMap[date] = td;
    }
    for (final d in taskDeposits) {
      final date = DateFormat("MM/dd/yyyy").format(d.date.toLocal());
      final td = dMap[date] ?? [];
      td.add(d);
      dMap[date] = td;
    }

    final totalEntries = dMap.entries.length;

    if (_isOpen.isEmpty || _isOpen.length != totalEntries) {
      _isOpen = List.filled(totalEntries, false);
    }

    final List<ExpansionPanel> expansionList = [];

    dMap.entries.toList().reversed.forEachIndexed((i, val) {
      final dList = val.value;
      dList.sort((a, b) {
        DateTime aDate = DateTime(0);
        DateTime bDate = DateTime(0);

        if (a is Deposit) {
          aDate = a.date;
        } else if (a is TaskDeposit) {
          aDate = a.date;
        }
        if (b is Deposit) {
          bDate = b.date;
        } else if (b is TaskDeposit) {
          bDate = b.date;
        }

        return bDate.compareTo(aDate);
      });

      String name = val.key;

      List<Widget> cardList = dList.map((el) {
        Widget card = Container();
        if (el is Deposit) {
          card = DepositCard(deposit: el);
        } else if (el is TaskDeposit) {
          card = TaskDepositCard(taskDeposit: el);
        }
        return card;
      }).toList();

      expansionList.add(ExpansionPanel(
        isExpanded: _isOpen[i],
        headerBuilder: (context, isOpen) {
          return ListTile(title: Text(name));
        },
        body: Column(children: cardList),
      ));
    });

    final expansion = ExpansionPanelList(
      children: expansionList,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _isOpen[panelIndex] = isExpanded;
        });
      },
    );

    return [
      TitleWidget(title: 'Deposit History'),
      expansion,
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
            child: AddTaskDepositForm(task: task),
          ),
        );
      },
    );
  }
}

class AddActionIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddIconButton(onPressed: openAddActionTaskDialog);
  }
}

class AddActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicBigTextButton(
      topMargin: 20,
      bottomMargin: 10,
      allPadding: 10,
      text: 'Add an Action or Task',
      onPressed: () {
        openAddActionTaskDialog(context);
      },
    );
  }
}

class AddActionTaskForm extends StatelessWidget {
  final Task? task;
  final VBAction? action;

  AddActionTaskForm({
    this.task,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    if (task != null) {
      return AddTaskForm(task: task!);
    }

    if (action != null) {
      return AddActionForm(action: action!);
    }

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
            AddActionForm(action: action),
            AddTaskForm(task: task),
          ],
        ),
      ),
    );
  }
}
