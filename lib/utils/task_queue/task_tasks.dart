import 'package:flutter_vice_bank/api/task_api.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/utils/task_queue/api_task.dart';

class TaskDepositTask implements APITask {
  final ViceBankProvider viceBankProvider;
  final TaskDeposit taskDeposit;
  final TaskAPI? taskAPI;

  TaskDeposit? _taskDepositResult;
  num? _currentTokens;

  TaskDeposit? get taskDepositResult => _taskDepositResult;
  num? get currentTokens => _currentTokens;

  TaskStatus _status = TaskStatus.pending;
  @override
  TaskStatus get status => _status;

  TaskDepositTask({
    required this.viceBankProvider,
    required this.taskDeposit,
    this.taskAPI,
  });

  @override
  Future<void> execute() async {
    _status = TaskStatus.running;
    try {
      final tAPI = taskAPI ?? TaskAPI();
      final result = await tAPI.addTaskDeposit(taskDeposit);

      _taskDepositResult = result.taskDeposit;
      _currentTokens = result.currentTokens;
      _status = TaskStatus.success;
    } catch (e) {
      _status = TaskStatus.pending;
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'taskDepositTask',
      'taskDeposit': taskDeposit.toJson(),
    };
  }
}
