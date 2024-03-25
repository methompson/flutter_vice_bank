import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:uuid/uuid.dart';

class Log {
  final String id;
  final String message;
  final MessageType type;
  final DateTime date;

  Log({
    required this.id,
    required this.message,
    required this.type,
    required this.date,
  });

  factory Log.fromJson(dynamic json) {
    const errMsg = 'Log.fromJson Failed:';

    final jsonMap = isTypeError<Map>(json, message: '$errMsg root');

    final id = isTypeError<String>(
      jsonMap['id'],
      message: '$errMsg id',
    );
    final message = isTypeError<String>(
      jsonMap['message'],
      message: '$errMsg message',
    );

    final typeString = isTypeError<String>(
      jsonMap['type'],
      message: '$errMsg type',
    );

    final dateString = isTypeError<String>(
      jsonMap['date'],
      message: '$errMsg date',
    );

    final date = DateTime.parse(dateString);
    final type = stringToMessageType(typeString);

    return Log(
      id: id,
      message: message,
      type: type,
      date: date,
    );
  }

  factory Log.info(String log) => Log.generic(log, MessageType.info);
  factory Log.error(String log) => Log.generic(log, MessageType.error);
  factory Log.warning(String log) => Log.generic(log, MessageType.warning);

  factory Log.generic(String log, MessageType type) {
    return Log(
      id: Uuid().v4(),
      message: log,
      type: type,
      date: DateTime.now(),
    );
  }

  Map<String, String> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'message': message,
      'type': messageTypeToString(type),
    };
  }
}
