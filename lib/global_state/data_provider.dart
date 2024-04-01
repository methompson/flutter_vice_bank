import 'package:flutter/cupertino.dart';

import 'package:flutter_vice_bank/utils/data_persistence/data_persistence.dart';

class DataProvider extends ChangeNotifier {
  DataPersistence? _dataPersistence;

  static final DataProvider _instance = DataProvider._();

  static DataProvider get instance => _instance;

  DataProvider._();

  Future<void> init({DataPersistence? dataPersistence}) async {
    _dataPersistence = dataPersistence ?? await DataPersistence().init();
    notifyListeners();
  }

  Future<void> setData(String key, String value) async {
    await _dataPersistence?.set(key, value);
  }

  Future<String?> getData(String key) async {
    return await _dataPersistence?.get(key);
  }
}
