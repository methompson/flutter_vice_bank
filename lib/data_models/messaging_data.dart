import 'package:uuid/uuid.dart';

class LoadingScreenData {
  final String message;
  final Function()? onCancel;

  LoadingScreenData({
    required this.message,
    this.onCancel,
  });
}

enum MessageType {
  success,
  error,
  warning,
  info,
}

String messageTypeToString(MessageType type) {
  switch (type) {
    case MessageType.success:
      return 'success';
    case MessageType.error:
      return 'error';
    case MessageType.warning:
      return 'warning';
    case MessageType.info:
      return 'info';
  }
}

MessageType stringToMessageType(String input) {
  switch (input) {
    case 'success':
      return MessageType.success;
    case 'error':
      return MessageType.error;
    case 'warning':
      return MessageType.warning;
    case 'info':
      return MessageType.info;
    default:
      throw ArgumentError('Invalid MessageType: $input');
  }
}

class SnackbarData {
  final String id;
  final String message;
  final MessageType type;

  SnackbarData({
    required this.id,
    required this.message,
    required this.type,
  });

  factory SnackbarData.success(String message) {
    return SnackbarData.generic(message, MessageType.success);
  }
  factory SnackbarData.error(String message) {
    return SnackbarData.generic(message, MessageType.error);
  }
  factory SnackbarData.info(String message) {
    return SnackbarData.generic(message, MessageType.info);
  }
  factory SnackbarData.warning(String message) {
    return SnackbarData.generic(message, MessageType.warning);
  }

  factory SnackbarData.generic(String message, MessageType type) {
    final id = Uuid().v4();

    return SnackbarData(
      id: id,
      message: message,
      type: type,
    );
  }
}
