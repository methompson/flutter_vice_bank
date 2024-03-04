import 'package:uuid/uuid.dart';

class LoadingScreenData {
  final String message;
  final Function()? onCancel;

  LoadingScreenData({
    required this.message,
    this.onCancel,
  });
}

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

class SnackbarData {
  final String id;
  final String message;
  final SnackbarType type;

  SnackbarData({
    required this.id,
    required this.message,
    required this.type,
  });

  factory SnackbarData.success(String message) {
    return SnackbarData.generic(message, SnackbarType.success);
  }
  factory SnackbarData.error(String message) {
    return SnackbarData.generic(message, SnackbarType.error);
  }
  factory SnackbarData.info(String message) {
    return SnackbarData.generic(message, SnackbarType.info);
  }
  factory SnackbarData.warning(String message) {
    return SnackbarData.generic(message, SnackbarType.warning);
  }

  factory SnackbarData.generic(String message, SnackbarType type) {
    final id = Uuid().v4();

    return SnackbarData(
      id: id,
      message: message,
      type: type,
    );
  }
}
