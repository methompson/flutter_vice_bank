import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter_vice_bank/utils/data_persistence/base.dart';

typedef OpenDatabaseFunction = Future<Database> Function(
  String path, {
  FutureOr<void> Function(Database, int)? onCreate,
  FutureOr<void> Function(Database)? onOpen,
  FutureOr<void> Function(Database)? onConfigure,
  FutureOr<void> Function(Database, int, int)? onUpgrade,
  int? version,
});

class DataPersistence extends AbstractDataPersistence {
  Database? db;

  @override
  Future<DataPersistence> init() async {
    await initDB();
    return this;
  }

  @visibleForTesting
  Future<void> initDB({
    OpenDatabaseFunction? openDatabaseFunction,
    String? path,
  }) async {
    final odf = openDatabaseFunction ?? openDatabase;
    final pa = path ?? await getDatabasesPath();

    db = await odf(
      join(pa, 'data.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE data(
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<String?> get(String key) async {
    final rawResponse = await db?.rawQuery(
      'SELECT key, value FROM data WHERE key = ?',
      [key],
    );

    if (rawResponse == null) {
      return null;
    }

    final result = isType<String>(
      rawResponse.first['value'],
    );

    return result;
  }

  @override
  Future<void> set(String key, String value) async {
    await db?.rawInsert(
      'REPLACE INTO data(key, value) VALUES(?, ?)',
      [key, value],
    );
  }
}
