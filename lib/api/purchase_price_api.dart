import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_vice_bank/api/api_common.dart';
import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class PurchasePriceAPI extends APICommon {
  Future<List<PurchasePrice>> getPurchasePrices(String userId) async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/purchasePrices',
      {'userId': userId},
    );

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final response = await http.get(
      uri,
      headers: headers,
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final purchasePriceList = isTypeError<List>(bodyJson['purchasePrices']);

    final List<PurchasePrice> purchasePrices = [];
    final errors = <dynamic>[];

    for (final d in purchasePriceList) {
      try {
        final purchasePrice = PurchasePrice.fromJson(d);
        purchasePrices.add(purchasePrice);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing purchasePrices: $errors',
      );
    }

    return purchasePrices;
  }

  Future<PurchasePrice> addPurchasePrice(PurchasePrice purchasePrice) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addPurchasePrice');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'purchasePrice': purchasePrice.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedPrice = PurchasePrice.fromJson(bodyJson['purchasePrice']);

    return addedPrice;
  }

  Future<PurchasePrice> updatePurchasePrice(PurchasePrice purchasePrice) async {
    final uri = getUri(baseDomain, '$baseApiUrl/updatePurchasePrice');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'purchasePrice': purchasePrice.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldPrice = PurchasePrice.fromJson(bodyJson['purchasePrice']);

    return oldPrice;
  }

  Future<PurchasePrice> deletePurchasePrice(String purchasePriceId) async {
    final uri = getUri(baseDomain, '$baseApiUrl/deletePurchasePrice');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'purchasePriceId': purchasePriceId,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final deletedPrice = PurchasePrice.fromJson(bodyJson['purchasePrice']);

    return deletedPrice;
  }
}
