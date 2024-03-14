import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

const viceBankUsersKey = 'vice_bank_users_key';
const viceBankCurrentUserKey = 'vice_bank_current_user_key';

class ViceBankProvider extends ChangeNotifier {
  Map<String, ViceBankUser> _users = {};

  ViceBankUser? _currentUser;
  ViceBankUser? get currentUser => _currentUser;

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

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();

    _users = {};
    _currentUser = null;
    _purchasePrices = [];
    _purchases = [];
    _depositConversions = [];
    _deposits = [];

    await prefs.remove(viceBankUsersKey);
    await prefs.remove(viceBankCurrentUserKey);
  }

  Future<void> init() async {
    try {
      final users = await getUsersFromSharedPrefs();

      _users = listToMap(users, (u) => u.id);

      _currentUser = await getCurrentUserFromSharedPrefs();
    } catch (e) {
      // print('Error getting users from prefs: $e');
    }
  }

  Future<ViceBankUser?> getCurrentUserFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUserString = prefs.getString(viceBankCurrentUserKey);

    if (currentUserString == null) {
      return null;
    }

    final userRaw = jsonDecode(currentUserString);

    final user = ViceBankUser.fromJson(userRaw);

    return user;
  }

  Future<List<ViceBankUser>> getUsersFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final usersString = prefs.getString(viceBankUsersKey);

    if (usersString == null) {
      return [];
    }

    final List<ViceBankUser> users = [];

    final usersRaw = jsonDecode(usersString);

    final usersList = isTypeError<List>(usersRaw);

    for (final u in usersList) {
      final user = ViceBankUser.fromJson(u);
      users.add(user);
    }

    return users;
  }

  /// Performs an inline sort for the deposits
  void sortDeposits() {
    _deposits.sort((a, b) => b.date.compareTo(a.date));
  }

  void sortPurchases() {
    _purchases.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> updateViceBankUserTokens(num currentTokens) async {
    final currentUser = _currentUser;

    if (currentUser == null) {
      return;
    }

    final updatedUser = currentUser.copyWith({
      'currentTokens': currentTokens,
    });

    _currentUser = updatedUser;
    _users[updatedUser.id] = updatedUser;

    await saveCurrentUserToSharedPrefs();
  }

  Future<void> selectUser(String? userId) async {
    if (userId == null) {
      _currentUser = null;
    } else {
      _currentUser = _users[userId];
    }

    await Future.wait([
      saveCurrentUserToSharedPrefs(),
      getDepositConversions(),
    ]);

    notifyListeners();
  }

  // Vice Bank User Functions
  Future<void> saveUsersToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(viceBankUsersKey, jsonEncode(users));
  }

  Future<void> saveCurrentUserToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cu = _currentUser;

    if (cu == null) {
      await prefs.setString(viceBankCurrentUserKey, '');
    } else {
      await prefs.setString(
        viceBankCurrentUserKey,
        jsonEncode(cu.toJson()),
      );
    }
  }

  Future<void> getViceBankUsers() async {
    final users = await viceBankUserApi.getViceBankUsers();

    _users = listToMap(users, (ViceBankUser u) => u.id);

    await saveUsersToSharedPrefs();

    notifyListeners();
  }

  Future<ViceBankUser> createUser(String name) async {
    final newUser = ViceBankUser.newUser(name: name, currentTokens: 0);

    final result = await viceBankUserApi.addViceBankUser(newUser);
    _users[result.id] = result;

    await saveUsersToSharedPrefs();

    notifyListeners();

    return result;
  }

  // Purchase Price Functions
  Future<void> getPurchasePrices() async {
    final cu = _currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _purchasePrices = await purchasePriceApi.getPurchasePrices(cu.id);
  }

  Future<void> createPurchasePrice(PurchasePrice price) async {
    final result = await purchasePriceApi.addPurchasePrice(price);

    _purchasePrices.add(result);

    notifyListeners();
  }

  // Purchase Functions
  Future<void> getPurchases() async {
    final cu = _currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _purchases = await purchaseApi.getPurchases(cu.id);

    sortPurchases();
    notifyListeners();
  }

  Future<void> addPurchase(Purchase purchase) async {
    final currentUser = _currentUser;

    if (currentUser == null) {
      throw Exception('No user selected');
    }

    final result = await purchaseApi.addPurchase(purchase);

    _purchases.add(result.purchase);
    sortPurchases();

    updateViceBankUserTokens(result.currentTokens);

    notifyListeners();
  }

  // Deposit Conversion Functions
  Future<void> getDepositConversions() async {
    final cu = _currentUser;
    if (cu == null) {
      // throw Exception('No user selected');
      return;
    }

    _depositConversions =
        await depositConversionApi.getDepositConversions(cu.id);

    notifyListeners();
  }

  Future<void> createDepositConversion(
    DepositConversion depositConversion,
  ) async {
    final result =
        await depositConversionApi.addDepositConversion(depositConversion);

    _depositConversions.add(result);

    notifyListeners();
  }

  // Deposit Functions
  Future<void> getDeposits() async {
    final cu = _currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _deposits = await depositApi.getDeposits(cu.id);

    notifyListeners();
  }

  Future<void> addDeposit(Deposit deposit) async {
    final result = await depositApi.addDeposit(deposit);

    _deposits.add(result.deposit);
    sortDeposits();

    updateViceBankUserTokens(result.currentTokens);

    notifyListeners();
  }
}
