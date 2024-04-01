import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:flutter_vice_bank/utils/type_checker.dart';

class VBAction {
  final String _id;
  final String _vbUserId;
  final String _name;
  final String _conversionUnit;
  final num _depositsPer;
  final num _tokensPer;
  final num _minDeposit;

  VBAction({
    required String id,
    required String vbUserId,
    required String name,
    required String conversionUnit,
    required num depositsPer,
    required num tokensPer,
    required num minDeposit,
  })  : _id = id,
        _vbUserId = vbUserId,
        _name = name,
        _conversionUnit = conversionUnit,
        _depositsPer = depositsPer,
        _tokensPer = tokensPer,
        _minDeposit = minDeposit;

  String get id => _id;
  String get vbUserId => _vbUserId;
  String get name => _name;
  String get conversionUnit => _conversionUnit;
  num get depositsPer => _depositsPer;
  num get tokensPer => _tokensPer;
  num get minDeposit => _minDeposit;

  num get conversionRate => _tokensPer / _depositsPer;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'vbUserId': _vbUserId,
      'name': _name,
      'conversionUnit': _conversionUnit,
      'depositsPer': _depositsPer,
      'tokensPer': _tokensPer,
      'minDeposit': _minDeposit,
    };
  }

  factory VBAction.newAction({
    required String vbUserId,
    required String name,
    required String conversionUnit,
    required num depositsPer,
    required num tokensPer,
    required num minDeposit,
  }) =>
      VBAction(
        id: Uuid().v4(),
        vbUserId: vbUserId,
        name: name,
        conversionUnit: conversionUnit,
        depositsPer: depositsPer,
        tokensPer: tokensPer,
        minDeposit: minDeposit,
      );

  factory VBAction.fromJson(dynamic json) {
    const errMsg = 'VBAction.fromJson Failed:';

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
    final conversionUnit = isTypeError<String>(
      jsonMap['conversionUnit'],
      message: '$errMsg conversionUnit',
    );
    final depositsPer = isTypeError<num>(
      jsonMap['depositsPer'],
      message: '$errMsg depositsPer',
    );
    final tokensPer = isTypeError<num>(
      jsonMap['tokensPer'],
      message: '$errMsg tokensPer',
    );
    final minDeposit = isTypeError<num>(
      jsonMap['minDeposit'],
      message: '$errMsg minDeposit',
    );

    return VBAction(
      id: id,
      vbUserId: vbUserId,
      name: name,
      conversionUnit: conversionUnit,
      depositsPer: depositsPer,
      tokensPer: tokensPer,
      minDeposit: minDeposit,
    );
  }

  static List<VBAction> parseJsonList(String input) {
    final json = jsonDecode(input);
    final rawList = isTypeError<List>(json);

    final List<VBAction> output = [];

    for (final p in rawList) {
      output.add(VBAction.fromJson(p));
    }

    return output;
  }
}
