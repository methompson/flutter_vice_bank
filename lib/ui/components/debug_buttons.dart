import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/log.dart';
import 'package:flutter_vice_bank/global_state/logging_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_vice_bank/api/deposit_api.dart';
import 'package:flutter_vice_bank/api/purchase_api.dart';
import 'package:flutter_vice_bank/api/purchase_price_api.dart';
import 'package:flutter_vice_bank/api/task_api.dart';
import 'package:flutter_vice_bank/api/vice_bank_user_api.dart';
import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/global_state/config_provider.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/utils/agent/agent.dart';
import 'package:flutter_vice_bank/utils/data_persistence/data_persistence.dart';
import 'package:flutter_vice_bank/utils/frequency.dart';

import 'package:flutter_vice_bank/ui/components/buttons.dart';

class DebugButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DisableDebugMode(),
        _ShowLoadingScreenWithCancelButton(),
        _ShowLoadingScreenWithAutoClose(),
        _ShowSnackBarMessage(),
        _AddSomeLogs(),
        _AllAPIsTest(),
        _AppInitialization(),
        _WebFunctions(),
        _DataPersistence(),
      ],
    );
  }
}

class DebugButton extends StatelessWidget {
  final String buttonText;
  final dynamic Function() onPressed;

  DebugButton({
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BasicTextButton(
      onPressed: onPressed,
      text: buttonText,
      topMargin: 10,
      bottomMargin: 10,
    );
  }
}

class _ShowLoadingScreenWithCancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Show Loading Screen with Cancel Button',
      onPressed: () {
        final msgProvider = context.read<MessagingProvider>();
        msgProvider.setLoadingScreenData(
          LoadingScreenData(
            message: 'Loading...',
            onCancel: () {
              msgProvider.clearLoadingScreen();
            },
          ),
        );
      },
    );
  }
}

class _ShowLoadingScreenWithAutoClose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Show Loading Screen with Fast Auto Close',
      onPressed: () {
        final msgProvider = context.read<MessagingProvider>();
        msgProvider.setLoadingScreenData(
          LoadingScreenData(
            message: 'Loading...',
          ),
        );

        Timer(Duration(milliseconds: 100), () {
          msgProvider.clearLoadingScreen();
        });
      },
    );
  }
}

class _ShowSnackBarMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Show Snack Bar Message',
      onPressed: () {
        context.read<MessagingProvider>().showErrorSnackbar('Error Message');
      },
    );
  }
}

class _AddSomeLogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Add Some Logs',
      onPressed: () {
        final lp = context.read<LoggingProvider>();

        final lastWeek = DateTime.now().subtract(Duration(days: 8));

        lp.logError('Test Error');
        lp.logInfo('Test Info');
        lp.logWarning('Test Warning');

        final log = Log(
          date: lastWeek,
          message: 'Old Log',
          type: MessageType.error,
          id: 'id',
        );

        lp.addLog(log);
      },
    );
  }
}

class _AllAPIsTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'All APIs Tests',
      onPressed: () async {
        final msgProvider = context.read<MessagingProvider>();
        final lp = context.read<LoggingProvider>();
        try {
          final vbp = context.read<ViceBankProvider>();

          final user = await testUserAPI(vbp);
          final action = await testActionAPI(vbp, user);
          final deposit = await testDepositAPI(vbp, action);
          final price = await purchasePriceAPI(vbp, user);
          final purchase = await purchaseAPI(vbp, price);
          final task = await testTaskAPI(vbp, user);
          final taskDeposit = await testTaskDepositAPI(vbp, task);

          await cleanup(
            vbp: vbp,
            action: action,
            deposit: deposit,
            price: price,
            purchase: purchase,
            task: task,
            taskDeposit: taskDeposit,
            user: user,
          );

          msgProvider.showSuccessSnackbar('All API Tests Passed');
        } catch (e, st) {
          msgProvider.showErrorSnackbar(e.toString());
          lp.logError(st.toString());
        }
      },
    );
  }

  Future<ViceBankUser> testUserAPI(ViceBankProvider vbp) async {
    final userToAdd = ViceBankUser.newUser(
      name: 'Mat Thompson',
      currentTokens: 0,
    );

    final vbApi = ViceBankUserAPI();

    final addedUser = await vbApi.addViceBankUser(userToAdd);

    assert(addedUser.id != userToAdd.id);

    await vbp.getViceBankUsers();

    await vbp.selectUser(addedUser.id);

    final users = vbp.users;
    users.retainWhere((el) => el.id == addedUser.id);

    assert(users.length == 1);

    final userToUpdate = ViceBankUser.fromJson({
      ...addedUser.toJson(),
      'name': 'Mickey Mouse',
    });

    final updatedUser = await vbApi.updateViceBankUser(userToUpdate);

    assert(updatedUser.id == addedUser.id);
    assert(updatedUser.name == addedUser.name);

    return userToUpdate;
  }

  Future<VBAction> testActionAPI(
    ViceBankProvider vbp,
    ViceBankUser user,
  ) async {
    final actionToAdd = VBAction.newAction(
      vbUserId: user.id,
      name: 'name',
      conversionUnit: 'conversionUnit',
      depositsPer: 1.0,
      tokensPer: 2.0,
      minDeposit: 3.0,
    );

    final action = await vbp.createAction(actionToAdd);

    assert(action.id != actionToAdd.id);

    final dcs = await vbp.getActions();

    dcs.retainWhere((el) => el.id == action.id);

    assert(dcs.length == 1);

    final actionToUpdate = VBAction.fromJson({
      ...action.toJson(),
      'depositsPer': 2.0,
    });

    final updatedAction = await vbp.updateAction(actionToUpdate);

    assert(updatedAction.depositsPer != actionToUpdate.depositsPer);

    return actionToUpdate;
  }

  Future<Deposit> testDepositAPI(ViceBankProvider vbp, VBAction action) async {
    final depositToAdd = Deposit.newDeposit(
      vbUserId: action.vbUserId,
      depositQuantity: 1.0,
      conversionRate: 1.0,
      action: action,
      conversionUnit: 'minutes',
    );

    final dApi = DepositAPI();

    final addedDeposit = (await dApi.addDeposit(depositToAdd)).deposit;

    assert(addedDeposit.id != depositToAdd.id);

    final deposits = await dApi.getDeposits(action.vbUserId);

    deposits.retainWhere((el) => el.id == addedDeposit.id);

    assert(deposits.length == 1);

    final depositToUpdate = Deposit.fromJson({
      ...addedDeposit.toJson(),
      'depositQuantity': 2.0,
    });

    final updatedDeposit = await dApi.updateDeposit(depositToUpdate);

    assert(updatedDeposit.oldDeposit.id == addedDeposit.id);
    assert(
      updatedDeposit.oldDeposit.depositQuantity !=
          depositToUpdate.depositQuantity,
    );

    return depositToUpdate;
  }

  Future<PurchasePrice> purchasePriceAPI(
    ViceBankProvider vbp,
    ViceBankUser user,
  ) async {
    final price = PurchasePrice.newPrice(
      vbUserId: user.id,
      name: 'name',
      price: 1.0,
    );

    final ppApi = PurchasePriceAPI();

    final addedPrice = await ppApi.addPurchasePrice(price);

    assert(addedPrice.id != price.id);

    final prices = await ppApi.getPurchasePrices(user.id);
    prices.retainWhere((el) => el.id == addedPrice.id);

    assert(prices.length == 1);

    final updatedPrice = PurchasePrice.fromJson({
      ...addedPrice.toJson(),
      'price': 2.0,
    });

    final updated = await vbp.updatePurchasePrice(updatedPrice);

    assert(updated.id == addedPrice.id);
    assert(updated.price != updatedPrice.price);

    return updatedPrice;
  }

  Future<Purchase> purchaseAPI(
      ViceBankProvider vbp, PurchasePrice price) async {
    final purchase = Purchase.newPurchase(
      purchasePrice: price,
      purchasedQuantity: 1,
    );

    final pApi = PurchaseAPI();

    final addedPurchase = (await pApi.addPurchase(purchase)).purchase;

    assert(purchase.id != addedPurchase.id);

    final purchases = await pApi.getPurchases(price.vbUserId);
    purchases.retainWhere((el) => el.id == addedPurchase.id);

    assert(purchases.length == 1);

    final purchaseToUpdate = Purchase.fromJson({
      ...addedPurchase.toJson(),
      'purchasedQuantity': 2,
    });

    final updatedPurchase = await pApi.updatePurchase(purchaseToUpdate);

    assert(purchaseToUpdate.id == updatedPurchase.id);
    assert(purchaseToUpdate.purchasedQuantity !=
        updatedPurchase.purchasedQuantity);

    return purchaseToUpdate;
  }

  Future<Task> testTaskAPI(
    ViceBankProvider vbp,
    ViceBankUser user,
  ) async {
    final taskToAdd = Task(
      id: 'id',
      vbUserId: user.id,
      name: 'Test Task',
      frequency: Frequency.daily,
      tokensPer: 1.0,
    );

    final task = await vbp.createTask(taskToAdd);

    final tasks = await vbp.getTasks();

    assert(tasks.length == 1);

    final taskToUpdate = Task.fromJson({
      ...task.toJson(),
      'name': 'Updated Task',
      'tokensPer': 1,
    });

    await vbp.updateTask(taskToUpdate);

    return taskToUpdate;
  }

  Future<TaskDeposit> testTaskDepositAPI(
    ViceBankProvider vbp,
    Task task,
  ) async {
    final taskApi = TaskAPI();

    final taskDepositToAdd = TaskDeposit.newTaskDeposit(
      task: task,
    );

    final taskDeposit = await taskApi.addTaskDeposit(taskDepositToAdd);

    final taskDeposits = await taskApi.getTaskDeposits(task.vbUserId);

    assert(taskDeposits.length == 1);

    final updatedTaskDeposit = TaskDeposit.fromJson({
      ...taskDeposit.taskDeposit.toJson(),
      'taskName': 'Updated Task',
      'tokensEarned': 1,
    });

    assert(taskDeposit.taskDeposit.id == updatedTaskDeposit.id);

    return updatedTaskDeposit;
  }

  Future<void> cleanup({
    required ViceBankProvider vbp,
    required VBAction action,
    required Deposit deposit,
    required PurchasePrice price,
    required Purchase purchase,
    required Task task,
    required TaskDeposit taskDeposit,
    required ViceBankUser user,
  }) async {
    final deletedDeposit = await DepositAPI().deleteDeposit(deposit.id);

    assert(deletedDeposit.deposit.id == deposit.id);
    assert(
      deletedDeposit.deposit.depositQuantity == deposit.depositQuantity,
    );

    final deletedTaskDeposit = await TaskAPI().deleteTaskDeposit(
      taskDeposit.id,
    );

    assert(deletedTaskDeposit.taskDeposit.id == taskDeposit.id);

    final deletedPurchase = await PurchaseAPI().deletePurchase(purchase.id);

    assert(deletedPurchase.id == purchase.id);
    assert(deletedPurchase.purchasedQuantity == purchase.purchasedQuantity);

    final deleted = await vbp.deletePurchasePrice(price);

    assert(deleted.id == price.id);
    assert(deleted.price == price.price);

    final deletedAction = await vbp.deleteAction(action);

    assert(deletedAction.depositsPer == action.depositsPer);

    final deletedTask = await vbp.deleteTask(task);

    assert(deletedTask.id == task.id);

    final deletedUser = await ViceBankUserAPI().deleteViceBankUser(user.id);

    assert(deletedUser.id == user.id);
    assert(deletedUser.name == user.name);
  }
}

class _AppInitialization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'App Data Init',
      onPressed: () async {
        final vbProvider = context.read<ViceBankProvider>();
        final msgProvider = context.read<MessagingProvider>();

        try {
          // create a user

          final user = await vbProvider.createUser('Mat Thompson');
          await vbProvider.selectUser(user.id);

          // add some actions
          final action = await vbProvider.createAction(
            VBAction.newAction(
              vbUserId: user.id,
              name: 'Read a Book',
              conversionUnit: 'minutes',
              depositsPer: 15,
              tokensPer: 0.25,
              minDeposit: 15,
            ),
          );

          // add some deposits
          await vbProvider.addDeposit(
            Deposit.newDeposit(
              vbUserId: user.id,
              depositQuantity: 60,
              conversionRate: action.conversionRate,
              action: action,
              conversionUnit: action.conversionUnit,
            ),
          );
          await vbProvider.addDeposit(
            Deposit.newDeposit(
              vbUserId: user.id,
              depositQuantity: 60,
              conversionRate: action.conversionRate,
              action: action,
              conversionUnit: action.conversionUnit,
            ),
          );

          // add some purchase prices
          final price = await vbProvider.createPurchasePrice(
            PurchasePrice.newPrice(
              vbUserId: user.id,
              name: 'Drink a Beer',
              price: 1,
            ),
          );
          // add some purchases

          await vbProvider.addPurchase(
            Purchase.newPurchase(
              purchasePrice: price,
              purchasedQuantity: 1,
            ),
          );

          final task = await vbProvider.createTask(Task.newTask(
            vbUserId: user.id,
            name: 'Write in your journal',
            frequency: Frequency.daily,
            tokensPer: 1,
          ));

          await vbProvider.addTaskDeposit(
            TaskDeposit.newTaskDeposit(task: task),
          );

          msgProvider.showSuccessSnackbar('App Initialization Complete');
        } catch (e) {
          msgProvider.showErrorSnackbar(e.toString());
        }
      },
    );
  }
}

class _DisableDebugMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Disable Debug Mode',
      onPressed: () {
        ConfigProvider.instance.setConfig('debugMode', false);
      },
    );
  }
}

class _WebFunctions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Web Functions',
      onPressed: () {
        final userAgent = AgentGetter().getUserAgent();

        MessagingProvider.instance.showSuccessSnackbar(
          'User Agent: $userAgent. kIsWeb: $kIsWeb. isPWA: ${AgentGetter().isPWA()}',
        );
      },
    );
  }
}

class _DataPersistence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Data Persistence Test',
      onPressed: () async {
        final pers = await DataPersistence().init();

        try {
          await pers.set('key', 'value');
          final result = await pers.get('key');

          assert(result == 'value');

          MessagingProvider.instance.showSuccessSnackbar(
            'Data Persistence Test Passed',
          );
        } catch (e) {
          MessagingProvider.instance.showErrorSnackbar(e.toString());
        }
      },
    );
  }
}
