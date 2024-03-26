import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:uuid/uuid.dart';

class Deposit {
  final String id;
  final String vbUserId;
  final DateTime date;
  final num depositQuantity;
  final num conversionRate;
  final String actionId;
  final String actionName;
  final String conversionUnit;

  Deposit({
    required this.id,
    required this.vbUserId,
    required this.date,
    required this.depositQuantity,
    required this.conversionRate,
    required this.actionName,
    required this.actionId,
    required this.conversionUnit,
  });

  num get tokensEarned {
    return depositQuantity * conversionRate;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vbUserId': vbUserId,
      'date': date.toIso8601String(),
      'depositQuantity': depositQuantity,
      'conversionRate': conversionRate,
      'actionId': actionId,
      'actionName': actionName,
      'conversionUnit': conversionUnit,
    };
  }

  factory Deposit.fromJson(dynamic json) {
    const errMsg = 'Deposit.fromJson Failed:';
    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(
      jsonMap['id'],
      message: '$errMsg id',
    );
    final vbUserId = isTypeError<String>(
      jsonMap['vbUserId'],
      message: '$errMsg vbUserId',
    );
    final dateString = isTypeError<String>(
      jsonMap['date'],
      message: '$errMsg date',
    );
    final depositQuantity = isTypeError<num>(
      jsonMap['depositQuantity'],
      message: '$errMsg depositQuantity',
    );
    final conversionRate = isTypeError<num>(
      jsonMap['conversionRate'],
      message: '$errMsg conversionRate',
    );
    final actionName = isTypeError<String>(
      jsonMap['actionName'],
      message: '$errMsg actionName',
    );
    final actionId = isTypeError<String>(
      jsonMap['actionId'],
      message: '$errMsg actionId',
    );
    final conversionUnit = isTypeError<String>(
      jsonMap['conversionUnit'],
      message: '$errMsg conversionUnit',
    );

    final date = DateTime.parse(dateString);

    return Deposit(
      id: id,
      vbUserId: vbUserId,
      date: date,
      depositQuantity: depositQuantity,
      conversionRate: conversionRate,
      actionId: actionId,
      actionName: actionName,
      conversionUnit: conversionUnit,
    );
  }

  factory Deposit.newDeposit({
    required String vbUserId,
    required num depositQuantity,
    required num conversionRate,
    required VBAction action,
    required String conversionUnit,
  }) {
    return Deposit(
      id: Uuid().v4(),
      vbUserId: vbUserId,
      date: DateTime.now(),
      depositQuantity: depositQuantity,
      conversionRate: conversionRate,
      actionId: action.id,
      actionName: action.name,
      conversionUnit: conversionUnit,
    );
  }
}
