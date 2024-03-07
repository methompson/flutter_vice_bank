import 'package:flutter_vice_bank/utils/type_checker.dart';

class ViceBankUser {
  final String _id;
  final String _name;
  final String _currentTokens;

  ViceBankUser({
    required String id,
    required String name,
    required String currentTokens,
  })  : _id = id,
        _name = name,
        _currentTokens = currentTokens;

  String get id => _id;
  String get name => _name;
  String get currentTokens => _currentTokens;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'currentTokens': _currentTokens,
    };
  }

  factory ViceBankUser.fromJson(dynamic json) {
    final jsonMap = isTypeError<Map>(json);

    final id = isTypeError<String>(jsonMap['id']);
    final name = isTypeError<String>(jsonMap['name']);
    final currentTokens = isTypeError<String>(jsonMap['currentTokens']);

    return ViceBankUser(
      id: id,
      name: name,
      currentTokens: currentTokens,
    );
  }
}
