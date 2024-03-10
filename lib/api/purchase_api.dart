import 'dart:convert';

import 'package:flutter_vice_bank/api/api_common.dart';
import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class PurchaseAPI extends APICommon {
  Future<List<Purchase>> getPurchases(String userId) async {
    final uri = Uri.http(
      baseDomain,
      '$baseApiUrl/purchases',
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
    final purchasesList = isTypeError<List>(bodyJson['purchases']);

    final List<Purchase> purchases = [];
    final errors = <dynamic>[];

    for (final p in purchasesList) {
      try {
        final purchase = Purchase.fromJson(p);
        purchases.add(purchase);
      } catch (e) {
        errors.add(e);
      }
    }

    print(response);

    return purchases;
  }

  Future<Purchase> addPurchase(Purchase purchase) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/addPurchase');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'purchase': purchase.toJson(),
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedPurchase = Purchase.fromJson(bodyJson['purchase']);

    print(response);
    print(response.body);

    return addedPurchase;
  }

  Future<Purchase> updatePurchase(Purchase purchase) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/updatePurchase');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'purchase': purchase.toJson(),
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldPurchase = Purchase.fromJson(bodyJson['purchase']);

    print(response);
    print(response.body);

    return oldPurchase;
  }

  Future<Purchase> deletePurchase(String purchaseId) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/deletePurchase');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'purchaseId': purchaseId,
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final deletedPurchase = Purchase.fromJson(bodyJson['purchase']);

    print(response);
    print(response.body);

    return deletedPurchase;
  }
}
