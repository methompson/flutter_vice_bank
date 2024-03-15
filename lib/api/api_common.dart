import 'package:flutter_vice_bank/utils/exceptions.dart';
import 'package:http/http.dart';

const baseDomain = 'localhost:8000';
const baseApiUrl = 'api/vice_bank';

abstract class APICommon {
  bool isOk(Response response) =>
      response.statusCode >= 200 && response.statusCode < 300;

  /// Throws an exception if the response is NOT OK
  commonResponseCheck(Response response, Uri uri) {
    if (!isOk(response)) {
      if (response.statusCode >= 400 && response.statusCode < 500) {
        throw Http400Exception(
            response.body, uri.toString(), response.statusCode);
      }

      if (response.statusCode >= 500) {
        throw Http500Exception(
            response.body, uri.toString(), response.statusCode);
      }
    }
  }
}
