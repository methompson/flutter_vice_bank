import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:flutter_vice_bank/utils/frequency.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class Task {
  final String _id;
  final String _vbUserId;
  final String _name;
  final Frequency _frequency;
  final num _tokensPer;

  Task({
    required String id,
    required String vbUserId,
    required String name,
    required Frequency frequency,
    required num tokensPer,
  })  : _id = id,
        _vbUserId = vbUserId,
        _name = name,
        _frequency = frequency,
        _tokensPer = tokensPer;

  String get id => _id;
  String get vbUserId => _vbUserId;
  String get name => _name;
  Frequency get frequency => _frequency;
  num get tokensPer => _tokensPer;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'vbUserId': _vbUserId,
      'name': _name,
      'frequency': frequencyToString(_frequency),
      'tokensPer': _tokensPer,
    };
  }

  factory Task.newTask({
    required String vbUserId,
    required String name,
    required Frequency frequency,
    required num tokensPer,
  }) =>
      Task(
        id: Uuid().v4(),
        vbUserId: vbUserId,
        name: name,
        frequency: frequency,
        tokensPer: tokensPer,
      );

  factory Task.fromJson(dynamic json) {
    const errMsg = 'Task.fromJson Failed:';

    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(
      jsonMap['id'],
      message: '$errMsg id',
    );
    final vbUserId = isTypeError<String>(
      jsonMap['vbUserId'],
      message: '$errMsg vbUserId',
    );
    final name = isTypeError<String>(
      jsonMap['name'],
      message: '$errMsg name',
    );
    final frequency = isTypeError<String>(
      jsonMap['frequency'],
      message: '$errMsg frequency',
    );
    final tokensPer = isTypeError<num>(
      jsonMap['tokensPer'],
      message: '$errMsg tokensPer',
    );

    return Task(
      id: id,
      vbUserId: vbUserId,
      name: name,
      frequency: stringToFrequency(frequency),
      tokensPer: tokensPer,
    );
  }

  static List<Task> parseJsonList(String input) {
    final json = jsonDecode(input);
    final rawList = isTypeError<List>(json);

    final List<Task> output = [];

    for (final p in rawList) {
      output.add(Task.fromJson(p));
    }

    return output;
  }
}
