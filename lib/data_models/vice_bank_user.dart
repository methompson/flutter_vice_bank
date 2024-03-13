import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:uuid/uuid.dart';

class ViceBankUser {
  final String _id;
  final String _userId;
  final String _name;
  final num _currentTokens;

  ViceBankUser({
    required String id,
    required String userId,
    required String name,
    required num currentTokens,
  })  : _id = id,
        _userId = userId,
        _name = name,
        _currentTokens = currentTokens;

  String get id => _id;
  String get userId => _userId;
  String get name => _name;
  num get currentTokens => _currentTokens;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'userId': _userId,
      'name': _name,
      'currentTokens': _currentTokens,
    };
  }

  ViceBankUser copyWith(Map<String, dynamic> input) => ViceBankUser.fromJson({
        ...toJson(),
        ...input,
      });

  factory ViceBankUser.newUser({
    required String name,
    required num currentTokens,
  }) {
    return ViceBankUser(
      id: Uuid().v4(),
      userId: '',
      name: name,
      currentTokens: currentTokens,
    );
  }

  factory ViceBankUser.fromJson(dynamic json) {
    const errMsg = 'ViceBankUser.fromJson Failed:';

    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(jsonMap['id'], message: '$errMsg id');
    final userId =
        isTypeError<String>(jsonMap['userId'], message: '$errMsg userId');
    final name = isTypeError<String>(jsonMap['name'], message: '$errMsg name');
    final currentTokens = isTypeError<num>(
      jsonMap['currentTokens'],
      message: '$errMsg currentTokens',
    );

    return ViceBankUser(
      id: id,
      userId: userId,
      name: name,
      currentTokens: currentTokens,
    );
  }
}
