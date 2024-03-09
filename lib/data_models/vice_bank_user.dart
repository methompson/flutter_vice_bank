import 'package:flutter_vice_bank/utils/type_checker.dart';

class ViceBankUser {
  final String _id;
  final String _name;
  final num _currentTokens;

  ViceBankUser({
    required String id,
    required String name,
    required num currentTokens,
  })  : _id = id,
        _name = name,
        _currentTokens = currentTokens;

  String get id => _id;
  String get name => _name;
  num get currentTokens => _currentTokens;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'currentTokens': _currentTokens,
    };
  }

  factory ViceBankUser.fromJson(dynamic json) {
    const errMsg = 'ViceBankUser.fromJson Failed:';

    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(jsonMap['id'], message: '$errMsg id');
    final name = isTypeError<String>(jsonMap['name'], message: '$errMsg name');
    final currentTokens = isTypeError<num>(
      jsonMap['currentTokens'],
      message: '$errMsg currentTokens',
    );

    return ViceBankUser(
      id: id,
      name: name,
      currentTokens: currentTokens,
    );
  }
}
