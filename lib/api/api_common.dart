import 'package:flutter/foundation.dart';

import 'package:flutter_vice_bank/utils/exceptions.dart';
import 'package:flutter_vice_bank/utils/http_service.dart';

const baseDomain = 'localhost:8000';
const baseApiUrl = 'api/vice_bank';

abstract class APICommon {
  HttpService _httpService = HttpService();

  @visibleForTesting
  set httpService(HttpService service) {
    _httpService = service;
  }

  HttpService get httpService => _httpService;

  /// Throws an exception if the response is NOT OK
  commonResponseCheck(HttpResponseData response, Uri uri) {
    if (!response.ok) {
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
