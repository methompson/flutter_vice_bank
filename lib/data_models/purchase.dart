import 'package:flutter_vice_bank/utils/type_checker.dart';

class Purchase {
  final String _id;
  final String _userId;
  final String _purchasePriceId;
  final DateTime _date;
  final num _purchasedQuantity;

  Purchase({
    required String id,
    required String userId,
    required String purchasePriceId,
    required DateTime date,
    required num purchasedQuantity,
  })  : _id = id,
        _userId = userId,
        _purchasePriceId = purchasePriceId,
        _date = date,
        _purchasedQuantity = purchasedQuantity;

  String get id => _id;
  String get userId => _userId;
  String get purchasePriceId => _purchasePriceId;
  DateTime get date => _date;
  num get purchasedQuantity => _purchasedQuantity;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'userId': _userId,
      'purchasePriceId': _purchasePriceId,
      'date': _date.toIso8601String(),
      'purchasedQuantity': _purchasedQuantity,
    };
  }

  factory Purchase.fromJson(dynamic json) {
    const errMsg = 'Purchase.fromJson Failed:';

    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(
      jsonMap['id'],
      message: '$errMsg id',
    );
    final userId = isTypeError<String>(
      jsonMap['userId'],
      message: '$errMsg userId',
    );
    final purchasePriceId = isTypeError<String>(
      jsonMap['purchasePriceId'],
      message: '$errMsg purchasePriceId',
    );
    final dateString = isTypeError<String>(
      jsonMap['date'],
      message: '$errMsg date',
    );
    final purchasedQuantity = isTypeError<double>(
      jsonMap['purchasedQuantity'],
      message: '$errMsg purchasedQuantity',
    );

    final date = DateTime.parse(dateString);

    return Purchase(
      id: id,
      userId: userId,
      purchasePriceId: purchasePriceId,
      date: date,
      purchasedQuantity: purchasedQuantity,
    );
  }
}
