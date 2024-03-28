import 'package:flutter_vice_bank/api/action_api.dart';
import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/utils/task_queue/api_task.dart';

class DepositTask implements APITask {
  final ViceBankProvider viceBankProvider;
  final Deposit deposit;
  final ActionAPI? actionAPI;

  Deposit? _depositResult;
  num? _currentTokens;

  Deposit? get depositResult => _depositResult;
  num? get currentTokens => _currentTokens;

  TaskStatus _status = TaskStatus.pending;
  @override
  TaskStatus get status => _status;

  DepositTask({
    required this.viceBankProvider,
    required this.deposit,
    this.actionAPI,
  });

  @override
  Future<void> execute() async {
    _status = TaskStatus.running;

    try {
      final dAPI = actionAPI ?? ActionAPI();
      final result = await dAPI.addDeposit(deposit);

      _depositResult = result.deposit;
      _currentTokens = result.currentTokens;
      _status = TaskStatus.success;
    } catch (e) {
      _status = TaskStatus.pending;
      rethrow;
    }
  }
}
