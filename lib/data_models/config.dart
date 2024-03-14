import 'dart:convert';

import 'package:flutter_vice_bank/utils/exceptions.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';

/// ConfigOption is standardized way to save scalar values to local storage.
/// It only supports string, number, and boolean types. Anything more complex
/// should be saved as a JSON string. Null values should be stored as empty
/// strings and any parsing operation should account for that.
class ConfigOption {
  final String key;
  final String value;

  ConfigOption({
    required this.key,
    required this.value,
  });

  String get string {
    return value;
  }

  num get number {
    try {
      return num.parse(value);
    } catch (e) {
      return double.nan;
    }
  }

  bool get boolean {
    return value.toLowerCase() == 'true';
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }

  factory ConfigOption.fromJson(dynamic input) {
    const errMsg = 'ConfigOption.fromJson Failed:';

    final json = isTypeError<Map>(
      input,
      message: '$errMsg root',
    );

    final value = isTypeError<String>(
      json['value'],
      message: '$errMsg value',
    );
    final key = isTypeError<String>(
      json['key'],
      message: '$errMsg key',
    );

    return ConfigOption(
      key: key,
      value: value,
    );
  }

  factory ConfigOption.newConfigOption({
    required String key,
    required dynamic value,
  }) {
    if (value == null) {
      throw InvalidInputException('Value cannot be null');
    }

    if (key.isEmpty) {
      throw InvalidInputException('Key cannot be an empty string');
    }

    if (isType<String>(value) != null) {
      return ConfigOption(key: key, value: value);
    }

    if (isType<num>(value) != null) {
      return ConfigOption(key: key, value: value.toString());
    }

    if (isType<bool>(value) != null) {
      return ConfigOption(key: key, value: value.toString());
    }

    if (isType<List>(value) != null || isType<Map>(value) != null) {
      return ConfigOption(key: key, value: jsonEncode(value));
    }

    throw InvalidInputException('Value type not supported');
  }

  static ConfigOption emptyConfigOption(String key) {
    return ConfigOption(key: key, value: '');
  }
}
