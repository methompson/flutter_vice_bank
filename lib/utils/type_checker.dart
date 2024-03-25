import 'package:flutter_vice_bank/utils/exceptions.dart';

T? isType<T>(dynamic input) {
  if (input is T) {
    return input;
  }

  return null;
}

T isTypeDefault<T>(dynamic input, T defaultValue) {
  if (input is T) {
    return input;
  }

  return defaultValue;
}

T isTypeError<T>(dynamic input, {Exception? exception, String? message}) {
  if (input is T) {
    return input;
  }

  if (exception != null) {
    throw exception;
  }

  throw TypeCheckException(message ?? 'Type check failed.');
}
