import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/log.dart';
import 'package:flutter_vice_bank/global_state/data_provider.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

class LoggingProvider extends ChangeNotifier {
  List<Log> _logs = [];

  static final LoggingProvider _instance = LoggingProvider._();

  static LoggingProvider get instance => _instance;

  LoggingProvider._();

  List<Log> get logs => [..._logs];

  String get logsJSON => jsonEncode(logs);

  Future<LoggingProvider> init() async {
    final logsRaw = await DataProvider.instance.getData('logs');

    try {
      final logsData = isTypeError<String>(logsRaw);
      final logsList = isTypeDefault<List>(jsonDecode(logsData), []);

      final List<Log> logs = [];

      for (final el in logsList) {
        try {
          final log = Log.fromJson(el);
          logs.add(log);
        } catch (e) {
          // print(e);
          // Do nothing for now
        }
      }

      _logs = logs;
    } catch (e) {
      // Do nothing for now
      // print(e);
    }

    return this;
  }

  void addLog(Log log) {
    _logs.add(log);
    sortLogs();
    notifyListeners();
  }

  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    addLog(Log.error(message));
    saveLogs();
  }

  void logWarning(String message, {Object? error, StackTrace? stackTrace}) {
    addLog(Log.warning(message));
    saveLogs();
  }

  void logInfo(String message) {
    addLog(Log.info(message));
    saveLogs();
  }

  Future<void> clearLogs() async {
    _logs = [];
    await saveLogs();
    notifyListeners();
  }

  void sortLogs() {
    final lastWeek = DateTime.now().subtract(Duration(days: 7));

    final filtered = _logs.where((el) => el.date.isAfter(lastWeek)).toList();
    filtered.sort((a, b) => b.date.compareTo(a.date));

    _logs = filtered;
  }

  Future<void> saveLogs() async {
    await DataProvider.instance.setData('logs', logsJSON);
  }
}
