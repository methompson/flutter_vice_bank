class ViceBankException implements Exception {
  final String message;

  ViceBankException(this.message);

  @override
  String toString() {
    return message;
  }
}

class TypeCheckException extends ViceBankException {
  TypeCheckException(super.message);
}
