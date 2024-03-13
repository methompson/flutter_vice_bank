import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:uuid/uuid.dart';

class PurchasePrice {
  final String _id;
  final String _userId;
  final String _name;
  final num _price;

  PurchasePrice({
    required String id,
    required String userId,
    required String name,
    required num price,
  })  : _id = id,
        _userId = userId,
        _name = name,
        _price = price;

  String get id => _id;
  String get userId => _userId;
  String get name => _name;
  num get price => _price;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'userId': _userId,
      'name': _name,
      'price': _price,
    };
  }

  factory PurchasePrice.newPrice({
    required String userId,
    required String name,
    required num price,
  }) =>
      PurchasePrice(
        id: Uuid().v4(),
        userId: userId,
        name: name,
        price: price,
      );

  factory PurchasePrice.fromJson(dynamic json) {
    const errMsg = 'PurchasePrice.fromJson Failed:';

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
    final price = isTypeError<num>(
      jsonMap['price'],
      message: '$errMsg price',
    );

    return PurchasePrice(
      id: id,
      userId: userId,
      name: name,
      price: price,
    );
  }
}
