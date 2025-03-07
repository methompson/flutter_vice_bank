import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/utils/frequency.dart';

abstract class TD {
  final DateTime _date;

  TD({required DateTime date}) : _date = date;

  DateTime get date => _date;
}

class Deposit extends TD {
  final String id;
  final String vbUserId;
  final num depositQuantity;
  final num conversionRate;
  final String actionId;
  final String actionName;
  final String conversionUnit;

  Deposit({
    required this.id,
    required this.vbUserId,
    required super.date,
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

  static List<Deposit> parseJsonList(String input) {
    final json = jsonDecode(input);
    final rawList = isTypeError<List>(json);

    final List<Deposit> output = [];

    for (final p in rawList) {
      output.add(Deposit.fromJson(p));
    }

    return output;
  }
}

class TaskDeposit extends TD {
  final String _id;
  final String _vbUserId;
  final DateTime _date;
  final String _taskName;
  final String _taskId;
  final num _conversionRate;
  final Frequency _frequency;
  final num _tokensEarned;

  TaskDeposit({
    required String id,
    required String vbUserId,
    required super.date,
    required String taskName,
    required String taskId,
    required num conversionRate,
    required Frequency frequency,
    required num tokensEarned,
  })  : _id = id,
        _vbUserId = vbUserId,
        _date = date,
        _taskName = taskName,
        _taskId = taskId,
        _conversionRate = conversionRate,
        _frequency = frequency,
        _tokensEarned = tokensEarned;

  String get id => _id;
  String get vbUserId => _vbUserId;
  DateTime get date => _date;
  String get taskName => _taskName;
  String get taskId => _taskId;
  num get conversionRate => _conversionRate;
  Frequency get frequency => _frequency;
  num get tokensEarned => _tokensEarned;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'vbUserId': _vbUserId,
      'date': _date.toIso8601String(),
      'taskName': _taskName,
      'taskId': _taskId,
      'conversionRate': _conversionRate,
      'frequency': frequencyToString(_frequency),
      'tokensEarned': _tokensEarned,
    };
  }

  factory TaskDeposit.newTaskDeposit({
    required Task task,
  }) =>
      TaskDeposit(
        id: Uuid().v4(),
        vbUserId: task.vbUserId,
        date: DateTime.now(),
        taskName: task.name,
        taskId: task.id,
        conversionRate: task.tokensPer,
        frequency: task.frequency,
        tokensEarned: task.tokensPer,
      );

  factory TaskDeposit.fromJson(dynamic json) {
    const errMsg = 'TaskDeposit.fromJson Failed:';

    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(
      jsonMap['id'],
      message: '$errMsg id',
    );
    final vbUserId = isTypeError<String>(
      jsonMap['vbUserId'],
      message: '$errMsg vbUserId',
    );
    final date = isTypeError<String>(
      jsonMap['date'],
      message: '$errMsg date',
    );
    final taskName = isTypeError<String>(
      jsonMap['taskName'],
      message: '$errMsg taskName',
    );
    final taskId = isTypeError<String>(
      jsonMap['taskId'],
      message: '$errMsg taskId',
    );
    final conversionRate = isTypeError<num>(
      jsonMap['conversionRate'],
      message: '$errMsg conversionRate',
    );
    final frequency = isTypeError<String>(
      jsonMap['frequency'],
      message: '$errMsg frequency',
    );
    final tokensEarned = isTypeError<num>(
      jsonMap['tokensEarned'],
      message: '$errMsg tokensEarned',
    );

    return TaskDeposit(
      id: id,
      vbUserId: vbUserId,
      date: DateTime.parse(date),
      taskName: taskName,
      taskId: taskId,
      conversionRate: conversionRate,
      frequency: stringToFrequency(frequency),
      tokensEarned: tokensEarned,
    );
  }

  static List<TaskDeposit> parseJsonList(String input) {
    final json = jsonDecode(input);
    final rawList = isTypeError<List>(json);

    final List<TaskDeposit> output = [];

    for (final p in rawList) {
      output.add(TaskDeposit.fromJson(p));
    }

    return output;
  }
}
