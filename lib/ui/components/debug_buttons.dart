import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/api/task_api.dart';
import 'package:flutter_vice_bank/data_models/task.dart';
import 'package:flutter_vice_bank/data_models/task_deposit.dart';
import 'package:flutter_vice_bank/utils/frequency.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_vice_bank/utils/agent/agent.dart';
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
import 'package:flutter_vice_bank/global_state/config_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';

import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
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
        _AllAPIsTest(),
        _AppInitialization(),
        _WebFunctions(),
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

class _AllAPIsTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'All APIs Tests',
      onPressed: () async {
        final msgProvider = context.read<MessagingProvider>();
        try {
          final vbp = context.read<ViceBankProvider>();

          final userToAdd = ViceBankUser.newUser(
            name: 'Mat Thompson',
            currentTokens: 0,
          );

          final vbApi = ViceBankUserAPI();

          final addedUser = await vbApi.addViceBankUser(userToAdd);

          assert(addedUser.id != userToAdd.id);

          await vbp.getViceBankUsers();

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

          final actionToAdd = VBAction.newAction(
            vbUserId: addedUser.id,
            name: 'name',
            conversionUnit: 'conversionUnit',
            depositsPer: 1.0,
            tokensPer: 2.0,
            minDeposit: 3.0,
          );

          final dcApi = ActionAPI();

          final dc = await dcApi.addAction(actionToAdd);

          assert(dc.id != actionToAdd.id);

          final dcs = await dcApi.getActions(addedUser.id);

          dcs.retainWhere((el) => el.id == dc.id);

          assert(dcs.length == 1);

          final dcToUpdate = VBAction.fromJson({
            ...dc.toJson(),
            'depositsPer': 2.0,
          });

          final updatedDc = await dcApi.updateAction(dcToUpdate);

          assert(updatedDc.depositsPer != dcToUpdate.depositsPer);

          final deletedDc = await dcApi.deleteAction(dc.id);

          assert(deletedDc.depositsPer == dcToUpdate.depositsPer);

          final depositToAdd = Deposit.newDeposit(
            vbUserId: addedUser.id,
            depositQuantity: 1.0,
            conversionRate: 1.0,
            actionName: 'actionName',
            conversionUnit: 'minutes',
          );

          final dApi = DepositAPI();

          final addedDeposit = (await dApi.addDeposit(depositToAdd)).deposit;

          assert(addedDeposit.id != depositToAdd.id);

          final deposits = await dApi.getDeposits(addedUser.id);

          deposits.retainWhere((el) => el.id == addedDeposit.id);

          assert(deposits.length == 1);

          final depositToUpdate = Deposit.fromJson({
            ...addedDeposit.toJson(),
            'depositQuantity': 2.0,
          });

          final updatedDeposit = await dApi.updateDeposit(depositToUpdate);

          assert(updatedDeposit.id == addedDeposit.id);
          assert(
            updatedDeposit.depositQuantity != depositToUpdate.depositQuantity,
          );

          final deletedDeposit = await dApi.deleteDeposit(addedDeposit.id);

          assert(deletedDeposit.id == addedDeposit.id);
          assert(
            deletedDeposit.depositQuantity == depositToUpdate.depositQuantity,
          );

          final price = PurchasePrice.newPrice(
            vbUserId: addedUser.id,
            name: 'name',
            price: 1.0,
          );

          final ppApi = PurchasePriceAPI();

          final addedPrice = await ppApi.addPurchasePrice(price);

          assert(addedPrice.id != price.id);

          final prices = await ppApi.getPurchasePrices(addedUser.id);
          prices.retainWhere((el) => el.id == addedPrice.id);

          assert(prices.length == 1);

          final updatedPrice = PurchasePrice.fromJson({
            ...addedPrice.toJson(),
            'price': 2.0,
          });

          final updated = await ppApi.updatePurchasePrice(updatedPrice);

          assert(updated.id == addedPrice.id);
          assert(updated.price != updatedPrice.price);

          final deleted = await ppApi.deletePurchasePrice(addedPrice.id);

          assert(deleted.id == addedPrice.id);
          assert(deleted.price == updatedPrice.price);

          final purchase = Purchase.newPurchase(
            vbUserId: addedUser.id,
            purchasePriceId: addedPrice.id,
            purchasedQuantity: 1,
            purchasedName: addedPrice.name,
          );

          final pApi = PurchaseAPI();

          final addedPurchase = (await pApi.addPurchase(purchase)).purchase;

          assert(purchase.id != addedPurchase.id);

          final purchases = await pApi.getPurchases(addedUser.id);
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

          final deletedPurchase = await pApi.deletePurchase(addedPurchase.id);

          assert(deletedPurchase.id == addedPurchase.id);
          assert(deletedPurchase.purchasedQuantity ==
              purchaseToUpdate.purchasedQuantity);

          final taskApi = TaskAPI();

          final taskToAdd = Task(
            id: 'id',
            vbUserId: updatedUser.id,
            name: 'Test Task',
            frequency: Frequency.daily,
            tokensPer: 1.0,
          );

          final task = await taskApi.addTask(taskToAdd);

          final tasks = await taskApi.getTasks(updatedUser.id);

          assert(tasks.length == 1);

          final taskToUpdate = Task.fromJson({
            ...task.toJson(),
            'name': 'Updated Task',
            'tokensPer': 1,
          });

          final updatedTask = await taskApi.updateTask(taskToUpdate);

          final taskDepositToAdd = TaskDeposit(
            id: 'id',
            vbUserId: updatedUser.id,
            date: DateTime.now(),
            taskName: updatedTask.name,
            taskId: updatedTask.id,
            conversionRate: updatedTask.tokensPer,
            frequency: updatedTask.frequency,
            tokensEarned: updatedTask.tokensPer,
          );

          final taskDeposit = await taskApi.addTaskDeposit(taskDepositToAdd);

          final taskDeposits = await taskApi.getTaskDeposits(updatedUser.id);

          assert(taskDeposits.length == 1);

          final updatedTaskDeposit = TaskDeposit.fromJson({
            ...taskDeposit.taskDeposit.toJson(),
            'taskName': 'Updated Task',
            'tokensEarned': 1,
          });

          assert(taskDeposit.taskDeposit.id == updatedTaskDeposit.id);

          final deletedTaskDeposit = await taskApi.deleteTaskDeposit(
            taskDeposit.taskDeposit.id,
          );

          assert(
              deletedTaskDeposit.taskDeposit.id == taskDeposit.taskDeposit.id);

          final deletedTask = await taskApi.deleteTask(task.id);

          assert(deletedTask.id == task.id);

          final deletedUser = await vbApi.deleteViceBankUser(addedUser.id);

          assert(deletedUser.id == addedUser.id);
          assert(deletedUser.name == userToUpdate.name);

          msgProvider.showSuccessSnackbar('All API Tests Passed');
        } catch (e) {
          msgProvider.showErrorSnackbar(e.toString());
        }
      },
    );
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
          final conversion = await vbProvider.createAction(
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
              conversionRate: conversion.conversionRate,
              actionName: conversion.name,
              conversionUnit: conversion.conversionUnit,
            ),
          );
          await vbProvider.addDeposit(
            Deposit.newDeposit(
              vbUserId: user.id,
              depositQuantity: 60,
              conversionRate: conversion.conversionRate,
              actionName: conversion.name,
              conversionUnit: conversion.conversionUnit,
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
              vbUserId: user.id,
              purchasePriceId: price.id,
              purchasedQuantity: 1,
              purchasedName: price.name,
            ),
          );

          final task = await vbProvider.createTask(Task.newTask(
            vbUserId: user.id,
            name: 'Write in your journal',
            frequency: Frequency.daily,
            tokensPer: 1,
          ));

          await vbProvider.addTaskDeposit(
            TaskDeposit.newTaskDeposit(vbUserId: user.id, task: task),
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
