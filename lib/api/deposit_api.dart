import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_vice_bank/api/api_common.dart';
import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

typedef AddDepositResponse = ({
  num currentTokens,
  Deposit deposit,
});

typedef UpdateDepositResponse = ({
  num currentTokens,
  Deposit deposit,
  Deposit oldDeposit,
});

typedef DeleteDepositResponse = ({
  num currentTokens,
  Deposit deposit,
});

class DepositAPI extends APICommon {
  // TODO use page and pagination
  Future<List<Deposit>> getDeposits(String userId) async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/deposits',
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
    final depositsList = isTypeError<List>(bodyJson['deposits']);

    final List<Deposit> deposits = [];
    final errors = <dynamic>[];

    for (final d in depositsList) {
      try {
        final deposit = Deposit.fromJson(d);
        deposits.add(deposit);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing deposits: $errors',
      );
    }

    return deposits;
  }

  Future<AddDepositResponse> addDeposit(Deposit deposit) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addDeposit');
    final token = await getAuthorizationToken();

    final Map<String, String> headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'deposit': deposit.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedDeposit = Deposit.fromJson(bodyJson['deposit']);
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);

    return (
      deposit: addedDeposit,
      currentTokens: currentTokens,
    );
  }

  Future<UpdateDepositResponse> updateDeposit(Deposit depositToUpdate) async {
    final uri = getUri(baseDomain, '$baseApiUrl/updateDeposit');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'deposit': depositToUpdate.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);
    final deposit = Deposit.fromJson(bodyJson['deposit']);
    final oldDeposit = Deposit.fromJson(bodyJson['oldDeposit']);

    return (
      oldDeposit: oldDeposit,
      deposit: deposit,
      currentTokens: currentTokens,
    );
  }

  Future<DeleteDepositResponse> deleteDeposit(String depositId) async {
    final uri = getUri(baseDomain, '$baseApiUrl/deleteDeposit');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'depositId': depositId,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);
    final deletedDeposit = Deposit.fromJson(bodyJson['deposit']);

    return (
      deposit: deletedDeposit,
      currentTokens: currentTokens,
    );
  }
}
