import 'package:flutter_vice_bank/utils/type_checker.dart';

class Purchase {
  final String _id;
  final String _vbUserId;
  final String _purchasePriceId;
  final DateTime _date;
  final int _purchasedQuantity;

  Purchase({
    required String id,
    required String vbUserId,
    required String purchasePriceId,
    required DateTime date,
    required int purchasedQuantity,
  })  : _id = id,
        _vbUserId = vbUserId,
        _purchasePriceId = purchasePriceId,
        _date = date,
        _purchasedQuantity = purchasedQuantity;

  String get id => _id;
  String get vbUserId => _vbUserId;
  String get purchasePriceId => _purchasePriceId;
  DateTime get date => _date;
  int get purchasedQuantity => _purchasedQuantity;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'vbUserId': _vbUserId,
      'purchasePriceId': _purchasePriceId,
      'date': _date.toIso8601String(),
      'purchasedQuantity': _purchasedQuantity,
    };
  }

  factory Purchase.newPurchase({
    required String vbUserId,
    required String purchasePriceId,
    required int purchasedQuantity,
  }) =>
      Purchase(
        id: '',
        vbUserId: vbUserId,
        purchasePriceId: purchasePriceId,
        date: DateTime.now(),
        purchasedQuantity: purchasedQuantity,
      );

  factory Purchase.fromJson(dynamic json) {
    const errMsg = 'Purchase.fromJson Failed:';

    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(
      jsonMap['id'],
      message: '$errMsg id',
    );
    final vbUserId = isTypeError<String>(
      jsonMap['vbUserId'],
      message: '$errMsg vbUserId',
    );
    final purchasePriceId = isTypeError<String>(
      jsonMap['purchasePriceId'],
      message: '$errMsg purchasePriceId',
    );
    final dateString = isTypeError<String>(
      jsonMap['date'],
      message: '$errMsg date',
    );
    final purchasedQuantity = isTypeError<int>(
      jsonMap['purchasedQuantity'],
      message: '$errMsg purchasedQuantity',
    );

    final date = DateTime.parse(dateString);

    return Purchase(
      id: id,
      vbUserId: vbUserId,
      purchasePriceId: purchasePriceId,
      date: date,
      purchasedQuantity: purchasedQuantity,
    );
  }
}
