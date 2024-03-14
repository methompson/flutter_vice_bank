import 'package:flutter/material.dart';

class LoggingProvider extends ChangeNotifier {
  static final LoggingProvider _instance = LoggingProvider._();

  static LoggingProvider get instance => _instance;

  LoggingProvider._();

  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    print('Error: $message');
  }

  void logWarning(String message, {Object? error, StackTrace? stackTrace}) {
    print('Warning: $message');
  }

  void logInfo(String message) {
    print('Info: $message');
  }
}
