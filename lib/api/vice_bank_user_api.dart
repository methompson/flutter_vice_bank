import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_vice_bank/api/api_common.dart';

import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class ViceBankUserAPI extends APICommon {
  Future<List<ViceBankUser>> getViceBankUsers() async {
    final uri = getUri(baseDomain, '$baseApiUrl/users');
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
    final usersList = isTypeError<List>(bodyJson['users']);

    final viceBankUsers = <ViceBankUser>[];
    final errors = <dynamic>[];

    for (final u in usersList) {
      try {
        final user = ViceBankUser.fromJson(u);
        viceBankUsers.add(user);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing users: $errors',
      );
    }

    return viceBankUsers;
  }

  Future<ViceBankUser> addViceBankUser(ViceBankUser user) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addUser');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'user': user.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedUser = ViceBankUser.fromJson(bodyJson['user']);

    return addedUser;
  }

  Future<ViceBankUser> updateViceBankUser(ViceBankUser user) async {
    final uri = getUri(baseDomain, '$baseApiUrl/updateUser');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'user': user.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldUser = ViceBankUser.fromJson(bodyJson['user']);

    return oldUser;
  }

  Future<ViceBankUser> deleteViceBankUser(String userId) async {
    final uri = getUri(baseDomain, '$baseApiUrl/deleteUser');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'viceBankUserId': userId,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final deletedUser = ViceBankUser.fromJson(bodyJson['user']);

    return deletedUser;
  }
}
