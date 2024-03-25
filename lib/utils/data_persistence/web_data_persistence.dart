import 'dart:html';

import 'package:flutter_vice_bank/utils/data_persistence/base.dart';

class DataPersistence extends AbstractDataPersistence {
  @override
  Future<DataPersistence> init() async {
    return this;
  }

  @override
  Future<String?> get(String key) async {
    return window.localStorage[key];
  }

  @override
  Future<void> set(String key, String value) async {
    window.localStorage[key] = value;
  }
}
