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

class HttpException extends ViceBankException {
  final String url;
  final num statusCode;

  HttpException(super.message, this.url, this.statusCode);
}

class Http400Exception extends HttpException {
  Http400Exception(super.message, super.url, super.statusCode);
}

class Http500Exception extends HttpException {
  Http500Exception(super.message, super.url, super.statusCode);
}

class InvalidInputException extends ViceBankException {
  InvalidInputException(super.message);
}
