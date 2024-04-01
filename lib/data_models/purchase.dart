import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class Purchase {
  final String id;
  final String vbUserId;
  final String purchasePriceId;
  final String purchasedName;
  final DateTime date;
  final int purchasedQuantity;

  Purchase({
    required this.id,
    required this.vbUserId,
    required this.purchasePriceId,
    required this.purchasedName,
    required this.date,
    required this.purchasedQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vbUserId': vbUserId,
      'purchasePriceId': purchasePriceId,
      'purchasedName': purchasedName,
      'date': date.toIso8601String(),
      'purchasedQuantity': purchasedQuantity,
    };
  }

  factory Purchase.newPurchase({
    required int purchasedQuantity,
    required PurchasePrice purchasePrice,
  }) =>
      Purchase(
        id: Uuid().v4(),
        vbUserId: purchasePrice.vbUserId,
        purchasePriceId: purchasePrice.id,
        purchasedName: purchasePrice.name,
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
    final purchasedName = isTypeError<String>(
      jsonMap['purchasedName'],
      message: '$errMsg purchasedName',
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
      purchasedName: purchasedName,
      date: date,
      purchasedQuantity: purchasedQuantity,
    );
  }

  static List<Purchase> parseJsonList(String input) {
    final json = jsonDecode(input);
    final rawList = isTypeError<List>(json);

    final List<Purchase> output = [];

    for (final p in rawList) {
      output.add(Purchase.fromJson(p));
    }

    return output;
  }
}
