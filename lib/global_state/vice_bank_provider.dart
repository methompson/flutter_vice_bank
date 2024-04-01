import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_vice_bank/api/action_api.dart';
import 'package:flutter_vice_bank/api/purchase_api.dart';
import 'package:flutter_vice_bank/api/task_api.dart';
import 'package:flutter_vice_bank/api/vice_bank_user_api.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';

import 'package:flutter_vice_bank/utils/list_to_map.dart';
import 'package:flutter_vice_bank/utils/task_queue/api_queue.dart';
import 'package:flutter_vice_bank/utils/task_queue/api_task.dart';
import 'package:flutter_vice_bank/utils/task_queue/deposit_tasks.dart';
import 'package:flutter_vice_bank/utils/task_queue/purchase_tasks.dart';
import 'package:flutter_vice_bank/utils/task_queue/task_tasks.dart';
import 'package:flutter_vice_bank/utils/type_checker.dart';
import 'package:flutter_vice_bank/global_state/data_provider.dart';

const viceBankUsersKey = 'vice_bank_users_key';
const viceBankCurrentUserKey = 'vice_bank_current_user_key';

class ViceBankProvider extends ChangeNotifier {
  Map<String, ViceBankUser> _users = {};

  String? _currentUser;
  ViceBankUser? get currentUser => _users[_currentUser ?? ''];

  late APITaskQueue _apiTaskQueue;
  @visibleForTesting
  APITaskQueue get apiTaskQueue => _apiTaskQueue;
  @visibleForTesting
  set apiTaskQueue(APITaskQueue queue) {
    _apiTaskQueue = queue;
  }

  num get totalTasks => _apiTaskQueue.totalTasks;

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

  TaskAPI? _taskAPI;
  @visibleForTesting
  TaskAPI get taskApi => _taskAPI ?? TaskAPI();
  @visibleForTesting
  set taskApi(TaskAPI api) {
    _taskAPI = api;
  }

  ViceBankProvider() {
    _apiTaskQueue = APITaskQueue(
      onTaskCompleted: onTaskCompleted,
    );
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

      await retrievePersistedData();

      await _apiTaskQueue.init(this);
    } catch (e) {
      // print('Error getting users from prefs: $e');
    }
  }

  // Data Persistence
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

  Future<void> persistData() async {
    final purchasePrices = _purchasePrices.map((p) => p.toJson()).toList();
    final purchases = _purchases.map((p) => p.toJson()).toList();
    final actions = _actions.map((a) => a.toJson()).toList();
    final deposits = _deposits.map((d) => d.toJson()).toList();
    final tasks = _tasks.map((t) => t.toJson()).toList();
    final taskDeposits = _taskDeposits.map((td) => td.toJson()).toList();

    final dp = DataProvider.instance;

    await Future.wait([
      dp.setData('purchasePrices', jsonEncode(purchasePrices)),
      dp.setData('purchases', jsonEncode(purchases)),
      dp.setData('actions', jsonEncode(actions)),
      dp.setData('deposits', jsonEncode(deposits)),
      dp.setData('tasks', jsonEncode(tasks)),
      dp.setData('taskDeposits', jsonEncode(taskDeposits)),
    ]);
  }

  Future<void> retrievePersistedData() async {
    final dp = DataProvider.instance;

    final [
      purchasePricesStr,
      purchasesStr,
      actionsStr,
      depositsStr,
      tasksStr,
      taskDepositsStr,
    ] = await Future.wait([
      dp.getData('purchasePrices'),
      dp.getData('purchases'),
      dp.getData('actions'),
      dp.getData('deposits'),
      dp.getData('tasks'),
      dp.getData('taskDeposits'),
    ]);

    try {
      _purchasePrices = PurchasePrice.parseJsonList(purchasePricesStr ?? '[]');
    } catch (e) {
      // print('Error getting data from data provider: $e');
    }

    try {
      _actions = VBAction.parseJsonList(actionsStr ?? '[]');
    } catch (e) {
      // print('Error getting data from data provider: $e');
    }

    try {
      _tasks = Task.parseJsonList(tasksStr ?? '[]');
    } catch (e) {
      // print('Error getting data from data provider: $e');
    }

    try {
      _purchases = Purchase.parseJsonList(purchasesStr ?? '[]');
    } catch (e) {
      // print('Error getting data from data provider: $e');
    }

    try {
      _deposits = Deposit.parseJsonList(depositsStr ?? '[]');
    } catch (e) {
      // print('Error getting data from data provider: $e');
    }

    try {
      _taskDeposits = TaskDeposit.parseJsonList(taskDepositsStr ?? '[]');
    } catch (e) {
      // print('Error getting data from data provider: $e');
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

  Future<void> clearTaskQueue() async {
    await _apiTaskQueue.clearTaskQueue();
    notifyListeners();
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
      getAllUserData(),
    ]);

    await persistData();

    notifyListeners();
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

    _purchasePrices = await purchaseApi.getPurchasePrices(cu.id);
  }

  Future<PurchasePrice> createPurchasePrice(PurchasePrice price) async {
    final result = await purchaseApi.addPurchasePrice(price);

    _purchasePrices.add(result);

    notifyListeners();

    return result;
  }

  Future<PurchasePrice> updatePurchasePrice(PurchasePrice price) async {
    final result = await purchaseApi.updatePurchasePrice(price);

    final filteredPrices =
        _purchasePrices.where((p) => p.id != result.id).toList();
    filteredPrices.add(price);

    _purchasePrices = filteredPrices;

    notifyListeners();

    return result;
  }

  Future<PurchasePrice> deletePurchasePrice(PurchasePrice price) async {
    final result = await purchaseApi.deletePurchasePrice(price.id);

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

  void addPurchase(Purchase purchase, num currentTokens) {
    _purchases.add(purchase);
    sortPurchases();

    updateViceBankUserTokens(currentTokens);

    notifyListeners();
  }

  Future<void> addPurchaseTask(Purchase purchase) async {
    _apiTaskQueue.addTask(PurchaseTask(
      viceBankProvider: this,
      purchase: purchase,
    ));

    notifyListeners();
  }

  Future<void> deletePurchase(Purchase purchase) async {
    final result = await purchaseApi.deletePurchase(purchase.id);

    _purchases.removeWhere((p) => p.id == purchase.id);

    updateViceBankUserTokens(result.currentTokens);

    notifyListeners();
  }

  Future<void> getAllUserData() async {
    await Future.wait([
      getActions(),
      getDeposits(),
      getPurchasePrices(),
      getPurchases(),
      getTasks(),
      getTaskDeposits(),
    ]);
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

    _deposits = await actionAPI.getDeposits(cu.id);

    notifyListeners();
  }

  void addDeposit(Deposit deposit, num currentTokens) {
    _deposits.add(deposit);
    sortDeposits();

    updateViceBankUserTokens(currentTokens);

    notifyListeners();
  }

  Future<void> addDepositTask(Deposit deposit) async {
    _apiTaskQueue.addTask(DepositTask(
      viceBankProvider: this,
      deposit: deposit,
    ));

    notifyListeners();
  }

  Future<Deposit> deleteDeposit(Deposit deposit) async {
    final result = await actionAPI.deleteDeposit(deposit.id);

    _deposits.removeWhere((d) => d.id == deposit.id);

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

  void addTaskDeposit(TaskDeposit taskDeposit, num currentTokens) {
    _taskDeposits.add(taskDeposit);
    sortTaskDeposits();

    updateViceBankUserTokens(currentTokens);

    notifyListeners();
  }

  Future<void> addTaskDepositTask(TaskDeposit taskDeposit) async {
    _apiTaskQueue.addTask(TaskDepositTask(
      viceBankProvider: this,
      taskDeposit: taskDeposit,
    ));

    notifyListeners();
  }

  Future<TaskDeposit> deleteTaskDeposit(TaskDeposit taskDeposit) async {
    final result = await taskApi.deleteTaskDeposit(taskDeposit.id);

    _taskDeposits.removeWhere((td) => td.id == taskDeposit.id);

    updateViceBankUserTokens(result.currentTokens);

    notifyListeners();

    return result.taskDeposit;
  }

  // Only using the the task queue for Purchases and Deposits. I'm not worried
  // about queuing up the other actions.
  void onTaskCompleted(APITask task) {
    if (task.status != TaskStatus.success) {
      return;
    }

    if (task is PurchaseTask) {
      final purchaseResult = task.purchaseResult;
      final currentTokens = task.currentTokens;

      if (purchaseResult != null && currentTokens != null) {
        addPurchase(purchaseResult, currentTokens);
      }

      notifyListeners();
      return;
    }

    if (task is DepositTask) {
      final depositResult = task.depositResult;
      final currentTokens = task.currentTokens;

      if (depositResult != null && currentTokens != null) {
        addDeposit(depositResult, currentTokens);
      }

      notifyListeners();
      return;
    }

    if (task is TaskDepositTask) {
      final taskDepositResult = task.taskDepositResult;
      final currentTokens = task.currentTokens;

      if (taskDepositResult != null && currentTokens != null) {
        addTaskDeposit(taskDepositResult, currentTokens);
      }

      notifyListeners();
      return;
    }
  }
}
