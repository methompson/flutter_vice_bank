T? isType<T>(dynamic input, T? defaultValue) {
  if (input is T) {
    return input;
  }

  return defaultValue;
}

T isTypeError<T>(dynamic input, {Exception? exception}) {
  if (input is T) {
    return input;
  }

  throw TypeError();
}
