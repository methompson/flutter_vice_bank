import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_vice_bank/api/api_common.dart';
import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';

typedef AddPurchaseResponse = ({
  Purchase purchase,
  num currentTokens,
});

typedef UpdatePurchaseResponse = ({
  Purchase purchase,
  Purchase oldPurchase,
  num currentTokens,
});

typedef DeletePurchaseResponse = ({
  Purchase purchase,
  num currentTokens,
});

class PurchaseAPI extends APICommon {
  Future<List<Purchase>> getPurchases(String userId) async {
    final uri = getUri(
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

  Future<AddPurchaseResponse> addPurchase(Purchase purchase) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addPurchase');
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

    return (
      purchase: addedPurchase,
      currentTokens: currentTokens,
    );
  }

  Future<UpdatePurchaseResponse> updatePurchase(
      Purchase purchaseToUpdate) async {
    final uri = getUri(baseDomain, '$baseApiUrl/updatePurchase');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'purchase': purchaseToUpdate.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);
    final oldPurchase = Purchase.fromJson(bodyJson['oldPurchase']);
    final purchase = Purchase.fromJson(bodyJson['purchase']);

    return (
      oldPurchase: oldPurchase,
      purchase: purchase,
      currentTokens: currentTokens,
    );
  }

  Future<DeletePurchaseResponse> deletePurchase(String purchaseId) async {
    final uri = getUri(baseDomain, '$baseApiUrl/deletePurchase');
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
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);
    final deletedPurchase = Purchase.fromJson(bodyJson['purchase']);

    return (
      purchase: deletedPurchase,
      currentTokens: currentTokens,
    );
  }

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
