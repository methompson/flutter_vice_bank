import 'dart:async';
import 'dart:convert';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:flutter_vice_bank/global_state/data_provider.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/utils/task_queue/api_task.dart';
import 'package:flutter_vice_bank/utils/task_queue/deposit_tasks.dart';
import 'package:flutter_vice_bank/utils/task_queue/purchase_tasks.dart';
import 'package:flutter_vice_bank/utils/task_queue/task_tasks.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class APITaskQueue {
  final List<APITask> _tasks = [];
  Timer? _timer;
  bool _working = false;

  num get totalTasks => _tasks.length;

  void Function(APITask task) onTaskCompleted;

  APITaskQueue({required this.onTaskCompleted});

  Future<void> clearTaskQueue() async {
    _tasks.clear();
    await persistTasks();
  }

  Future<void> init(ViceBankProvider vbProvider) async {
    final dataProvider = DataProvider.instance;

    final tasksData = await dataProvider.getData('apiTasks');

    print('tasksData');

    if (tasksData != null) {
      final tasksRaw = jsonDecode(tasksData);

      final tasks = isTypeDefault<List>(tasksRaw, []);

      for (final task in tasks) {
        try {
          final map = isTypeError<Map>(task);
          final taskType = isTypeError<String>(map['type']);

          switch (taskType) {
            case 'depositTask':
              final task = DepositTask(
                viceBankProvider: vbProvider,
                deposit: Deposit.fromJson(map['deposit']),
              );
              _tasks.add(task);
              break;
            case 'taskDepositTask':
              final task = TaskDepositTask(
                viceBankProvider: vbProvider,
                taskDeposit: TaskDeposit.fromJson(map['taskDeposit']),
              );
              _tasks.add(task);
              break;
            case 'purchaseTask':
              final task = PurchaseTask(
                viceBankProvider: vbProvider,
                purchase: Purchase.fromJson(map['purchase']),
              );
              _tasks.add(task);
              break;
          }
        } catch (e) {
          LoggingProvider.instance.logError('Failed to load task', error: e);
        }
      }
    }

    execute();
  }

  Future<void> addTask(APITask task) async {
    _tasks.add(task);

    try {
      await persistTasks();
    } catch (e) {
      LoggingProvider.instance.logError('Failed to persist tasks', error: e);
    }

    execute();
  }

  Future<void> execute() async {
    _timer?.cancel();

    if (_tasks.isEmpty) {
      _working = false;
      return;
    }

    if (_working) {
      return;
    }

    _working = true;

    try {
      while (true) {
        if (_tasks.isEmpty) {
          _working = false;
          return;
        }
        final task = _tasks[0];
        await task.execute();
        _tasks.removeAt(0);

        await persistTasks();

        onTaskCompleted(task);
      }
    } catch (e) {
      _timer = Timer(Duration(seconds: 30), execute);
      _working = false;
      return;
    }
  }

  Future<void> persistTasks() async {
    final dataProvider = DataProvider.instance;

    final tasksData = _tasks.map((e) => e.toJson()).toList();

    await dataProvider.setData('apiTasks', jsonEncode(tasksData));
  }
}
