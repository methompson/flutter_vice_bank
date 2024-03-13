import 'dart:convert';

import 'package:flutter_vice_bank/api/api_common.dart';
import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class DepositResponse {
  final Deposit deposit;
  final num currentTokens;

  DepositResponse({
    required this.deposit,
    required this.currentTokens,
  });
}

class DepositAPI extends APICommon {
  // TODO use page and pagination
  Future<List<Deposit>> getDeposits(String userId) async {
    final uri = Uri.http(
      baseDomain,
      '$baseApiUrl/deposits',
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

    // TODO Log the errors

    return deposits;
  }

  Future<DepositResponse> addDeposit(Deposit deposit) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/addDeposit');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'deposit': deposit.toJson(),
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedDeposit = Deposit.fromJson(bodyJson['deposit']);
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);

    return DepositResponse(
      deposit: addedDeposit,
      currentTokens: currentTokens,
    );
  }

  Future<Deposit> updateDeposit(Deposit deposit) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/updateDeposit');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'deposit': deposit.toJson(),
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldDeposit = Deposit.fromJson(bodyJson['deposit']);

    return oldDeposit;
  }

  Future<Deposit> deleteDeposit(String depositId) async {
    final uri = Uri.http(baseDomain, '$baseApiUrl/deleteDeposit');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
    };

    final Map<String, dynamic> body = {
      'depositId': depositId,
    };

    final response = await httpService.postJson(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final deletedDeposit = Deposit.fromJson(bodyJson['deposit']);

    return deletedDeposit;
  }
}
