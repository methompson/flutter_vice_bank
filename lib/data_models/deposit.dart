import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:uuid/uuid.dart';

class Deposit {
  final String _id;
  final String _vbUserId;
  final DateTime _date;
  final num _depositQuantity;
  final num _conversionRate;
  final String _actionName;
  final String _conversionUnit;

  Deposit({
    required String id,
    required String vbUserId,
    required DateTime date,
    required num depositQuantity,
    required num conversionRate,
    required String actionName,
    required String conversionUnit,
  })  : _id = id,
        _vbUserId = vbUserId,
        _date = date,
        _depositQuantity = depositQuantity,
        _conversionRate = conversionRate,
        _actionName = actionName,
        _conversionUnit = conversionUnit;

  String get id => _id;
  String get vbUserId => _vbUserId;
  DateTime get date => _date;
  num get depositQuantity => _depositQuantity;
  num get conversionRate => _conversionRate;
  String get actionName => _actionName;
  String get conversionUnit => _conversionUnit;

  num get tokensEarned {
    return _depositQuantity * _conversionRate;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'vbUserId': _vbUserId,
      'date': _date.toIso8601String(),
      'depositQuantity': _depositQuantity,
      'conversionRate': _conversionRate,
      'actionName': _actionName,
      'conversionUnit': _conversionUnit,
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
      actionName: actionName,
      conversionUnit: conversionUnit,
    );
  }

  factory Deposit.newDeposit({
    required String vbUserId,
    required num depositQuantity,
    required num conversionRate,
    required String actionName,
    required String conversionUnit,
  }) {
    return Deposit(
      id: Uuid().v4(),
      vbUserId: vbUserId,
      date: DateTime.now(),
      depositQuantity: depositQuantity,
      conversionRate: conversionRate,
      actionName: actionName,
      conversionUnit: conversionUnit,
    );
  }
}
