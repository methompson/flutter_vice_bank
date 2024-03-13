import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:uuid/uuid.dart';

class DepositConversion {
  final String _id;
  final String _userId;
  final String _name;
  final String _conversionUnit;
  final num _depositsPer;
  final num _tokensPer;
  final num _minDeposit;

  DepositConversion({
    required String id,
    required String userId,
    required String name,
    required String conversionUnit,
    required num depositsPer,
    required num tokensPer,
    required num minDeposit,
  })  : _id = id,
        _userId = userId,
        _name = name,
        _conversionUnit = conversionUnit,
        _depositsPer = depositsPer,
        _tokensPer = tokensPer,
        _minDeposit = minDeposit;

  String get id => _id;
  String get userId => _userId;
  String get name => _name;
  String get conversionUnit => _conversionUnit;
  num get depositsPer => _depositsPer;
  num get tokensPer => _tokensPer;
  num get minDeposit => _minDeposit;

  get conversionRate => _tokensPer / _depositsPer;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'userId': _userId,
      'name': _name,
      'conversionUnit': _conversionUnit,
      'depositsPer': _depositsPer,
      'tokensPer': _tokensPer,
      'minDeposit': _minDeposit,
    };
  }

  factory DepositConversion.newConversion({
    required String userId,
    required String name,
    required String conversionUnit,
    required num depositsPer,
    required num tokensPer,
    required num minDeposit,
  }) =>
      DepositConversion(
        id: Uuid().v4(),
        userId: userId,
        name: name,
        conversionUnit: conversionUnit,
        depositsPer: depositsPer,
        tokensPer: tokensPer,
        minDeposit: minDeposit,
      );

  factory DepositConversion.fromJson(dynamic json) {
    const errMsg = 'DepositConversion.fromJson Failed:';

    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(
      jsonMap['id'],
      message: '$errMsg id',
    );
    final userId = isTypeError<String>(
      jsonMap['userId'],
      message: '$errMsg userId',
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

    return DepositConversion(
      id: id,
      userId: userId,
      name: name,
      conversionUnit: conversionUnit,
      depositsPer: depositsPer,
      tokensPer: tokensPer,
      minDeposit: minDeposit,
    );
  }
}
