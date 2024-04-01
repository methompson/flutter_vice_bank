import 'package:http/http.dart';

import 'package:flutter_vice_bank/env.dart';
import 'package:flutter_vice_bank/utils/exceptions.dart';

abstract class APICommon {
  final baseApiUrl = 'api/vice_bank';

  final prodBaseDomain = 'api.methompson.com';
  final devBaseDomain = 'localhost:8000';

  String get baseDomain => isProd ? prodBaseDomain : devBaseDomain;

  Uri getUri(
    String authority, [
    String unencodedPath = '',
    Map<String, dynamic>? queryParameters,
  ]) {
    const uriFunction = isProd ? Uri.https : Uri.http;

    return uriFunction(
      authority,
      unencodedPath,
      queryParameters,
    );
  }

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
