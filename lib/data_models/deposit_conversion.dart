import 'package:flutter_vice_bank/utils/type_checker.dart';

class DepositConversion {
  final String _id;
  final String _userId;
  final String _name;
  final String _rateName;
  final double _depositsPer;
  final double _tokensPer;
  final double _minDeposit;

  DepositConversion({
    required String id,
    required String userId,
    required String name,
    required String rateName,
    required double depositsPer,
    required double tokensPer,
    required double minDeposit,
  })  : _id = id,
        _userId = userId,
        _name = name,
        _rateName = rateName,
        _depositsPer = depositsPer,
        _tokensPer = tokensPer,
        _minDeposit = minDeposit;

  String get id => _id;
  String get userId => _userId;
  String get name => _name;
  String get rateName => _rateName;
  double get depositsPer => _depositsPer;
  double get tokensPer => _tokensPer;
  double get minDeposit => _minDeposit;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'userId': _userId,
      'name': _name,
      'rateName': _rateName,
      'depositsPer': _depositsPer,
      'tokensPer': _tokensPer,
      'minDeposit': _minDeposit,
    };
  }

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
    final rateName = isTypeError<String>(
      jsonMap['rateName'],
      message: '$errMsg rateName',
    );
    final depositsPer = isTypeError<double>(
      jsonMap['depositsPer'],
      message: '$errMsg depositsPer',
    );
    final tokensPer = isTypeError<double>(
      jsonMap['tokensPer'],
      message: '$errMsg tokensPer',
    );
    final minDeposit = isTypeError<double>(
      jsonMap['minDeposit'],
      message: '$errMsg minDeposit',
    );

    return DepositConversion(
      id: id,
      userId: userId,
      name: name,
      rateName: rateName,
      depositsPer: depositsPer,
      tokensPer: tokensPer,
      minDeposit: minDeposit,
    );
  }
}
