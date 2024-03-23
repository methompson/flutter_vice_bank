import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_vice_bank/api/task_api.dart';
import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_vice_bank/api/deposit_api.dart';
import 'package:flutter_vice_bank/api/action_api.dart';
import 'package:flutter_vice_bank/api/purchase_api.dart';
import 'package:flutter_vice_bank/api/purchase_price_api.dart';
import 'package:flutter_vice_bank/api/vice_bank_user_api.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/utils/list_to_map.dart';

const viceBankUsersKey = 'vice_bank_users_key';
const viceBankCurrentUserKey = 'vice_bank_current_user_key';

class ViceBankProvider extends ChangeNotifier {
  Map<String, ViceBankUser> _users = {};

  String? _currentUser;
  ViceBankUser? get currentUser => _users[_currentUser ?? ''];

  List<PurchasePrice> _purchasePrices = [];
  List<Purchase> _purchases = [];
  List<VBAction> _actions = [];
  List<Deposit> _deposits = [];
  List<Task> _tasks = [];
  List<TaskDeposit> _taskDeposits = [];

  List<ViceBankUser> get users => [..._users.values];
  List<PurchasePrice> get purchasePrices => [..._purchasePrices];
  List<Purchase> get purchases => [..._purchases];
  List<VBAction> get actions => [..._actions];
  List<Deposit> get deposits => [..._deposits];
  List<Task> get tasks => [..._tasks];
  List<TaskDeposit> get taskDeposits => [..._taskDeposits];

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

  ActionAPI? _actionAPI;
  @visibleForTesting
  ActionAPI get actionAPI => _actionAPI ?? ActionAPI();
  @visibleForTesting
  set actionAPI(ActionAPI api) {
    _actionAPI = api;
  }

  DepositAPI? _depositAPI;
  @visibleForTesting
  DepositAPI get depositApi => _depositAPI ?? DepositAPI();
  @visibleForTesting
  set depositApi(DepositAPI api) {
    _depositAPI = api;
  }

  TaskAPI? _taskAPI;
  @visibleForTesting
  TaskAPI get taskApi => _taskAPI ?? TaskAPI();
  @visibleForTesting
  set taskApi(TaskAPI api) {
    _taskAPI = api;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();

    _users = {};
    _currentUser = null;
    _purchasePrices = [];
    _purchases = [];
    _actions = [];
    _deposits = [];
    _tasks = [];
    _taskDeposits = [];

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

  Future<String?> getCurrentUserFromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUserId = prefs.getString(viceBankCurrentUserKey);

    if (currentUserId == null) {
      return null;
    }

    return currentUserId;
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

  void sortTaskDeposits() {
    _taskDeposits.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> updateViceBankUserTokens(num currentTokens) async {
    final cu = currentUser;

    if (cu == null) {
      return;
    }

    final updatedUser = cu.copyWith({
      'currentTokens': currentTokens,
    });

    _users[updatedUser.id] = updatedUser;

    await saveCurrentUserToSharedPrefs();
  }

  Future<void> selectUser(String? userId) async {
    if (userId == null) {
      _currentUser = null;
    } else {
      _currentUser = userId;
    }

    await Future.wait([
      saveCurrentUserToSharedPrefs(),
      getActions(),
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
        cu,
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
    final cu = currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _purchasePrices = await purchasePriceApi.getPurchasePrices(cu.id);
  }

  Future<PurchasePrice> createPurchasePrice(PurchasePrice price) async {
    final result = await purchasePriceApi.addPurchasePrice(price);

    _purchasePrices.add(result);

    notifyListeners();

    return result;
  }

  Future<PurchasePrice> updatePurchasePrice(PurchasePrice price) async {
    final result = await purchasePriceApi.updatePurchasePrice(price);

    final filteredPrices =
        _purchasePrices.where((p) => p.id != result.id).toList();
    filteredPrices.add(price);

    _purchasePrices = filteredPrices;

    notifyListeners();

    return result;
  }

  Future<PurchasePrice> deletePurchasePrice(PurchasePrice price) async {
    final result = await purchasePriceApi.deletePurchasePrice(price.id);

    _purchasePrices.removeWhere((p) => p.id == price.id);

    notifyListeners();

    return result;
  }

  // Purchase Functions
  Future<void> getPurchases() async {
    final cu = currentUser;
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

  // Action Functions
  Future<List<VBAction>> getActions() async {
    final cu = currentUser;
    if (cu == null) {
      // throw Exception('No user selected');
      return [];
    }

    _actions = await actionAPI.getActions(cu.id);

    notifyListeners();

    return _actions;
  }

  Future<VBAction> createAction(
    VBAction action,
  ) async {
    final result = await actionAPI.addAction(action);

    _actions.add(result);

    notifyListeners();

    return result;
  }

  Future<VBAction> updateAction(
    VBAction action,
  ) async {
    final result = await actionAPI.updateAction(action);

    final filteredActions = _actions.where((a) => a.id != result.id).toList();
    filteredActions.add(action);

    _actions = filteredActions;

    notifyListeners();

    return result;
  }

  Future<VBAction> deleteAction(VBAction action) async {
    final result = await actionAPI.deleteAction(action.id);

    _actions.removeWhere((a) => a.id == action.id);

    notifyListeners();

    return result;
  }

  // Deposit Functions
  Future<void> getDeposits() async {
    final cu = currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _deposits = await depositApi.getDeposits(cu.id);

    notifyListeners();
  }

  Future<Deposit> addDeposit(Deposit deposit) async {
    final result = await depositApi.addDeposit(deposit);

    _deposits.add(result.deposit);
    sortDeposits();

    updateViceBankUserTokens(result.currentTokens);

    notifyListeners();

    return result.deposit;
  }

  Future<List<Task>> getTasks() async {
    final cu = currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _tasks = await taskApi.getTasks(cu.id);

    notifyListeners();

    return _tasks;
  }

  Future<Task> createTask(Task task) async {
    final result = await taskApi.addTask(task);

    _tasks.add(result);

    notifyListeners();

    return result;
  }

  Future<Task> updateTask(Task task) async {
    final result = await taskApi.updateTask(task);

    final filteredTasks = _tasks.where((t) => t.id != result.id).toList();
    filteredTasks.add(task);

    _tasks = filteredTasks;

    notifyListeners();

    return result;
  }

  Future<Task> deleteTask(Task task) async {
    final result = await taskApi.deleteTask(task.id);

    _tasks.removeWhere((t) => t.id == task.id);

    notifyListeners();

    return result;
  }

  Future<void> getTaskDeposits() async {
    final cu = currentUser;
    if (cu == null) {
      throw Exception('No user selected');
    }

    _taskDeposits = await taskApi.getTaskDeposits(cu.id);

    notifyListeners();
  }

  Future<TaskDeposit> addTaskDeposit(TaskDeposit taskDeposit) async {
    final result = await taskApi.addTaskDeposit(taskDeposit);

    _taskDeposits.add(result.taskDeposit);
    sortTaskDeposits();

    updateViceBankUserTokens(result.currentTokens);

    notifyListeners();

    return result.taskDeposit;
  }
}
