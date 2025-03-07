import 'dart:convert';

import 'package:flutter_vice_bank/api/auth_utils.dart';
import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/api/api_common.dart';

typedef AddTaskDepositResponse = ({
  num currentTokens,
  TaskDeposit taskDeposit,
});

typedef UpdateTaskDepositResponse = ({
  num currentTokens,
  TaskDeposit taskDeposit,
  TaskDeposit oldTaskDeposit,
});

typedef DeleteTaskDepositResponse = ({
  num currentTokens,
  TaskDeposit taskDeposit,
});

class TaskAPI extends APICommon {
  Future<List<Task>> getTasks(String userId) async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/tasks',
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
    final tasksList = isTypeError<List>(bodyJson['tasks']);

    final List<Task> tasks = [];
    final errors = <dynamic>[];

    for (final t in tasksList) {
      try {
        final task = Task.fromJson(t);
        tasks.add(task);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing tasks: $errors',
      );
    }

    return tasks;
  }

  Future<Task> addTask(Task task) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addTask');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'task': task.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final addedTask = Task.fromJson(bodyJson['task']);

    return addedTask;
  }

  Future<Task> updateTask(Task task) async {
    final uri = getUri(baseDomain, '$baseApiUrl/updateTask');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'task': task.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final oldPrice = Task.fromJson(bodyJson['task']);

    return oldPrice;
  }

  Future<Task> deleteTask(String taskId) async {
    final uri = getUri(baseDomain, '$baseApiUrl/deleteTask');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'taskId': taskId,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final deletedTask = Task.fromJson(bodyJson['task']);

    return deletedTask;
  }

  Future<List<TaskDeposit>> getTaskDeposits(String userId) async {
    final uri = getUri(
      baseDomain,
      '$baseApiUrl/taskDeposits',
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
    final tasksList = isTypeError<List>(bodyJson['taskDeposits']);

    final List<TaskDeposit> tasks = [];
    final errors = <dynamic>[];

    for (final t in tasksList) {
      try {
        final taskDeposit = TaskDeposit.fromJson(t);
        tasks.add(taskDeposit);
      } catch (e) {
        errors.add(e);
      }
    }

    if (errors.isNotEmpty) {
      LoggingProvider.instance.logError(
        'Error parsing task: $errors',
      );
    }

    return tasks;
  }

  Future<AddTaskDepositResponse> addTaskDeposit(TaskDeposit taskDeposit) async {
    final uri = getUri(baseDomain, '$baseApiUrl/addTaskDeposit');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'taskDeposit': taskDeposit.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);
    final addedtaskDeposit = TaskDeposit.fromJson(bodyJson['taskDeposit']);

    return (
      taskDeposit: addedtaskDeposit,
      currentTokens: currentTokens,
    );
  }

  Future<UpdateTaskDepositResponse> updateTaskDeposit(
      TaskDeposit taskDepositToUpdate) async {
    final uri = getUri(baseDomain, '$baseApiUrl/updateTaskDeposit');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'taskDeposit': taskDepositToUpdate.toJson(),
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final taskDeposit = TaskDeposit.fromJson(bodyJson['taskDeposit']);
    final oldTaskDeposit = TaskDeposit.fromJson(bodyJson['oldTaskDeposit']);
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);

    return (
      oldTaskDeposit: oldTaskDeposit,
      taskDeposit: taskDeposit,
      currentTokens: currentTokens,
    );
  }

  Future<DeleteTaskDepositResponse> deleteTaskDeposit(
      String taskDepositId) async {
    final uri = getUri(baseDomain, '$baseApiUrl/deleteTaskDeposit');
    final token = await getAuthorizationToken();

    final headers = {
      'authorization': token,
      'content-type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'taskDepositId': taskDepositId,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    commonResponseCheck(response, uri);

    final bodyJson = isTypeError<Map>(jsonDecode(response.body));
    final deletedTaskDeposit = TaskDeposit.fromJson(bodyJson['taskDeposit']);
    final currentTokens = isTypeError<num>(bodyJson['currentTokens']);

    return (
      taskDeposit: deletedTaskDeposit,
      currentTokens: currentTokens,
    );
  }
}
