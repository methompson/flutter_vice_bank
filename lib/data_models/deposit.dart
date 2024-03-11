import 'package:flutter_vice_bank/utils/type_checker.dart';

class Deposit {
  final String _id;
  final String _userId;
  final DateTime _date;
  final num _depositQuantity;
  final num _conversionRate;
  final String _depositConversionName;

  Deposit({
    required String id,
    required String userId,
    required DateTime date,
    required num depositQuantity,
    required num conversionRate,
    required String depositConversionName,
  })  : _id = id,
        _userId = userId,
        _date = date,
        _depositQuantity = depositQuantity,
        _conversionRate = conversionRate,
        _depositConversionName = depositConversionName;

  String get id => _id;
  String get userId => _userId;
  DateTime get date => _date;
  num get depositQuantity => _depositQuantity;
  num get conversionRate => _conversionRate;
  String get depositConversionName => _depositConversionName;

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'userId': _userId,
      'date': _date.toIso8601String(),
      'depositQuantity': _depositQuantity,
      'conversionRate': _conversionRate,
      'depositConversionName': _depositConversionName,
    };
  }

  factory Deposit.fromJson(dynamic json) {
    const errMsg = 'Deposit.fromJson Failed:';
    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(
      jsonMap['id'],
      message: '$errMsg id',
    );
    final userId = isTypeError<String>(
      jsonMap['userId'],
      message: '$errMsg userId',
    );
    final dateString = isTypeError<String>(
      jsonMap['date'],
      message: '$errMsg date',
    );
    final depositQuantity = isTypeError<num>(
      jsonMap['depositQuantity'],
      message: '$errMsg depositQuantity',
    );
    final conversionRate = isTypeError<num>(
      jsonMap['conversionRate'],
      message: '$errMsg conversionRate',
    );
    final depositConversionName = isTypeError<String>(
      jsonMap['depositConversionName'],
      message: '$errMsg depositConversionName',
    );

    final date = DateTime.parse(dateString);

    return Deposit(
      id: id,
      userId: userId,
      date: date,
      depositQuantity: depositQuantity,
      conversionRate: conversionRate,
      depositConversionName: depositConversionName,
    );
  }
}
