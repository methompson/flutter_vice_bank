import 'package:flutter_vice_bank/api/purchase_api.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/utils/task_queue/api_task.dart';

class PurchaseTask implements APITask {
  final ViceBankProvider viceBankProvider;
  final Purchase purchase;
  final PurchaseAPI? purchaseAPI;
  Purchase? _purchaseResult;
  num? _currentTokens;

  TaskStatus _status = TaskStatus.pending;
  @override
  TaskStatus get status => _status;

  Purchase? get purchaseResult => _purchaseResult;
  num? get currentTokens => _currentTokens;

  PurchaseTask({
    required this.viceBankProvider,
    required this.purchase,
    this.purchaseAPI,
  });

  @override
  Future<void> execute() async {
    _status = TaskStatus.running;

    try {
      final pApi = purchaseAPI ?? PurchaseAPI();
      final result = await pApi.addPurchase(purchase);

      _purchaseResult = result.purchase;
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
      'type': 'purchaseTask',
      'purchase': purchase.toJson(),
    };
  }
}
