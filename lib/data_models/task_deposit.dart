import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/utils/frequency.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class TaskDeposit {
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
    required DateTime date,
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
    required String vbUserId,
    required Task task,
  }) =>
      TaskDeposit(
        id: '',
        vbUserId: vbUserId,
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
}
