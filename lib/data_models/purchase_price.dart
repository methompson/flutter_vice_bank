import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:uuid/uuid.dart';

class PurchasePrice {
  final String _id;
  final String _vbUserId;
  final String _name;
  final num _price;

  PurchasePrice({
    required String id,
    required String vbUserId,
    required String name,
    required num price,
  })  : _id = id,
        _vbUserId = vbUserId,
        _name = name,
        _price = price;

  String get id => _id;
  String get vbUserId => _vbUserId;
  String get name => _name;
  num get price => _price;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'vbUserId': _vbUserId,
      'name': _name,
      'price': _price,
    };
  }

  factory PurchasePrice.newPrice({
    required String vbUserId,
    required String name,
    required num price,
  }) =>
      PurchasePrice(
        id: Uuid().v4(),
        vbUserId: vbUserId,
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
    final vbUserId = isTypeError<String>(
      jsonMap['vbUserId'],
      message: '$errMsg vbUserId',
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
      vbUserId: vbUserId,
      name: name,
      price: price,
    );
  }
}
