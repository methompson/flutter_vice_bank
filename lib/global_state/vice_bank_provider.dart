import 'package:flutter/cupertino.dart';
import 'package:flutter_vice_bank/api/deposit_api.dart';
import 'package:flutter_vice_bank/api/deposit_conversion_api.dart';
import 'package:flutter_vice_bank/api/purchase_api.dart';
import 'package:flutter_vice_bank/api/purchase_price_api.dart';
import 'package:flutter_vice_bank/api/vice_bank_user_api.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/deposit_conversion.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/utils/list_to_map.dart';

class ViceBankProvider extends ChangeNotifier {
  Map<String, ViceBankUser> _users = {};

  ViceBankUser? _currentUser;

  List<PurchasePrice> _purchasePrices = [];
  List<Purchase> _purchases = [];
  List<DepositConversion> _depositConversions = [];
  List<Deposit> _deposits = [];

  List<ViceBankUser> get users => [..._users.values];
  List<PurchasePrice> get purchasePrices => [..._purchasePrices];
  List<Purchase> get purchases => [..._purchases];
  List<DepositConversion> get depositConversions => [..._depositConversions];
  List<Deposit> get deposits => [..._deposits];

  ViceBankUserAPI? _viceBankUserAPI;
  @visibleForTesting
  ViceBankUserAPI get viceBankUserApi => _viceBankUserAPI ?? ViceBankUserAPI();
  @visibleForTesting
  set viceBankuserApi(ViceBankUserAPI api) {
    _viceBankUserAPI = api;
  }

  PurchasePriceAPI? _purchasePriceAPI;
  @visibleForTesting
  PurchasePriceAPI get purchasePriceApi =>
      _purchasePriceAPI ?? PurchasePriceAPI();
  @visibleForTesting
  set purchasePriceApi(PurchasePriceAPI api) {
    _purchasePriceAPI = api;
  }

  PurchaseAPI? _purchaseAPI;
  @visibleForTesting
  PurchaseAPI get purchaseApi => _purchaseAPI ?? PurchaseAPI();
  @visibleForTesting
  set purchaseApi(PurchaseAPI api) {
    _purchaseAPI = api;
  }

  DepositConversionAPI? _depositConversionAPI;
  @visibleForTesting
  DepositConversionAPI get depositConversionApi =>
      _depositConversionAPI ?? DepositConversionAPI();
  @visibleForTesting
  set depositConversionApi(DepositConversionAPI api) {
    _depositConversionAPI = api;
  }

  DepositAPI? _depositAPI;
  @visibleForTesting
  DepositAPI get depositApi => _depositAPI ?? DepositAPI();
  @visibleForTesting
  set depositApi(DepositAPI api) {
    _depositAPI = api;
  }

  void selectUser(String? userId) {
    if (userId == null) {
      _currentUser = null;
    } else {
      _currentUser = _users[userId];
    }

    notifyListeners();
  }

  Future<void> getViceBankUsers() async {
    final users = await viceBankUserApi.getViceBankUsers();

    _users = listToMap(users, (ViceBankUser u) => u.id);
  }

  Future<void> getPurchasePrices() async {
    final cu = _currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _purchasePrices = await purchasePriceApi.getPurchasePrices(cu.id);
  }

  Future<void> getPurchases() async {
    final cu = _currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _purchases = await purchaseApi.getPurchases(cu.id);
  }

  Future<void> getDepositConversions() async {
    final cu = _currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _depositConversions =
        await depositConversionApi.getDepositConversions(cu.id);
  }

  Future<void> getDeposits() async {
    final cu = _currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _deposits = await depositApi.getDeposits(cu.id);
  }
}
