import 'package:flutter/cupertino.dart';
import 'package:flutter_vice_bank/utils/data_persistence/base.dart';

class DataProvider extends ChangeNotifier {
  DataPersistence? _dataPersistence;

  static final DataProvider _instance = DataProvider._();

  static DataProvider get instance => _instance;

  DataProvider._();
}
