import 'dart:convert';

import 'package:flutter_vice_bank/api/api_common.dart';
import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class PurchasePriceAPI extends APICommon {
  Future<List<PurchasePrice>> getPurchasePrices(String userId) async {
    final uri = Uri.http(
      baseDomain,
      '$baseApiUrl/purchasePrices',
      {'userId': userId},
    );

    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final response = await httpService.get(
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

    // TODO Log the errors

    print(response);

    return purchasePrices;
  }

  Future<PurchasePrice> addPurchasePrice(PurchasePrice purchasePrice) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/addPurchasePrice');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'purchasePrice': purchasePrice.toJson(),
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedPrice = PurchasePrice.fromJson(bodyJson['purchasePrice']);

    print(response);
    print(response.body);

    return addedPrice;
  }

  Future<PurchasePrice> updatePurchasePrice(PurchasePrice purchasePrice) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/updatePurchasePrice');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'purchasePrice': purchasePrice.toJson(),
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldPrice = PurchasePrice.fromJson(bodyJson['purchasePrice']);

    print(response);
    print(response.body);

    return oldPrice;
  }

  Future<PurchasePrice> deletePurchasePrice(String purchasePriceId) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/deletePurchasePrice');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'purchasePriceId': purchasePriceId,
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final deletedPrice = PurchasePrice.fromJson(bodyJson['purchasePrice']);

    print(response);
    print(response.body);

    return deletedPrice;
  }
}
