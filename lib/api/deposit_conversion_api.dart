import 'dart:convert';

import 'package:flutter_vice_bank/api/api_common.dart';
import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/deposit_conversion.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class DepositConversionAPI extends APICommon {
  Future<List<DepositConversion>> getDepositConversions(String userId) async {
    final uri = Uri.http(
      baseDomain,
      '$baseApiUrl/depositConversions',
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
    final depositsList = isTypeError<List>(bodyJson['depositConversions']);

    final List<DepositConversion> depositConversions = [];
    final errors = <dynamic>[];

    for (final d in depositsList) {
      try {
        final deposit = DepositConversion.fromJson(d);
        depositConversions.add(deposit);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing depositConversions: $errors',
      );
    }

    return depositConversions;
  }

  Future<DepositConversion> addDepositConversion(
    DepositConversion depositConversion,
  ) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/addDepositConversion');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'depositConversion': depositConversion.toJson(),
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedDeposit =
        DepositConversion.fromJson(bodyJson['depositConversion']);

    return addedDeposit;
  }

  Future<DepositConversion> updateDepositConversion(
    DepositConversion depositConversion,
  ) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/updateDepositConversion');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'depositConversion': depositConversion.toJson(),
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldDeposit =
        DepositConversion.fromJson(bodyJson['depositConversion']);

    return oldDeposit;
  }

  Future<DepositConversion> deleteDepositConversion(
    String depositConversionId,
  ) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/deleteDepositConversion');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'depositConversionId': depositConversionId,
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final deletedDeposit =
        DepositConversion.fromJson(bodyJson['depositConversion']);

    return deletedDeposit;
  }
}
