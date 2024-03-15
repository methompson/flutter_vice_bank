import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_vice_bank/api/api_common.dart';
import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class PurchaseResponse {
  final Purchase purchase;
  final num currentTokens;

  PurchaseResponse({
    required this.purchase,
    required this.currentTokens,
  });
}

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

    final response = await http.get(
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

    return purchases;
  }

  Future<PurchaseResponse> addPurchase(Purchase purchase) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/addPurchase');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'purchase': purchase.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedPurchase = Purchase.fromJson(bodyJson['purchase']);
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);

    return PurchaseResponse(
      purchase: addedPurchase,
      currentTokens: currentTokens,
    );
  }

  Future<Purchase> updatePurchase(Purchase purchase) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/updatePurchase');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'purchase': purchase.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldPurchase = Purchase.fromJson(bodyJson['purchase']);

    return oldPurchase;
  }

  Future<Purchase> deletePurchase(String purchaseId) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/deletePurchase');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'purchaseId': purchaseId,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final deletedPurchase = Purchase.fromJson(bodyJson['purchase']);

    return deletedPurchase;
  }
}
