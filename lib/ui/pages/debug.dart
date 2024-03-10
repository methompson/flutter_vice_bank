import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:uuid/uuid.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ShowLoadingScreenWithCancelButton(),
        _ShowLoadingScreenWithAutoClose(),
        _ShowSnackBarMessage(),
        _ViceBankUsersTest(),
        _DepositApiTest(),
        _DepositConversionApiTest(),
        _PurchaseApiTest(),
        _PurchasePriceApiTest(),
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
    return Container(
      margin: EdgeInsets.all(10),
      child: BasicTextButton(
        onPressed: onPressed,
        text: buttonText,
      ),
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

class _ViceBankUsersTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Vice Bank Users Tests',
      onPressed: () async {
        try {
          final userToAdd = ViceBankUser(
            id: Uuid().v4(),
            name: 'Mat Thompson',
            currentTokens: 0,
          );

          final apis = ViceBankUserAPI();

          final addedUser = await apis.addViceBankUser(userToAdd);

          assert(addedUser.id != userToAdd.id);

          final users = await apis.getViceBankUsers();

          users.retainWhere((el) => el.id == addedUser.id);

          assert(users.length == 1);

          final userToUpdate = ViceBankUser.fromJson({
            ...addedUser.toJson(),
            'name': 'Mickey Mouse',
          });

          final updatedUser = await apis.updateViceBankUser(userToUpdate);

          assert(updatedUser.id == addedUser.id);
          assert(updatedUser.name == addedUser.name);

          final deletedUser = await apis.deleteViceBankUser(addedUser.id);

          assert(deletedUser.id == addedUser.id);
          assert(deletedUser.name == userToUpdate.name);

          print('done');
        } catch (e) {
          print(e);
        }
      },
    );
  }
}

class _DepositApiTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Deposit Tests',
      onPressed: () async {
        try {
          final depositToAdd = Deposit(
            id: Uuid().v4(),
            userId: 'userId',
            date: DateTime.now(),
            depositQuantity: 1.0,
            conversionRate: 1.0,
            depositConversionName: 'depositConversionName',
          );

          final apis = DepositAPI();

          final addedDeposit = await apis.addDeposit(depositToAdd);

          assert(addedDeposit.id != depositToAdd.id);

          final deposits = await apis.getDeposits('userId');

          print('Total Deposits: ${deposits.length}');

          deposits.retainWhere((el) => el.id == addedDeposit.id);

          assert(deposits.length == 1);

          final depositToUpdate = Deposit.fromJson({
            ...addedDeposit.toJson(),
            'depositQuantity': 2.0,
          });

          final updatedDeposit = await apis.updateDeposit(depositToUpdate);

          assert(updatedDeposit.id == addedDeposit.id);
          assert(
            updatedDeposit.depositQuantity != depositToUpdate.depositQuantity,
          );

          final deletedDeposit = await apis.deleteDeposit(addedDeposit.id);

          assert(deletedDeposit.id == addedDeposit.id);
          assert(
            deletedDeposit.depositQuantity == depositToUpdate.depositQuantity,
          );
        } catch (e) {
          print(e);
        }
      },
    );
  }
}

class _DepositConversionApiTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Deposit Conversion Tests',
      onPressed: () async {
        try {
          final depositConversionToAdd = DepositConversion(
            id: Uuid().v4(),
            userId: 'userId',
            name: 'name',
            rateName: 'rateName',
            depositsPer: 1.0,
            tokensPer: 2.0,
            minDeposit: 3.0,
          );

          final api = DepositConversionAPI();

          final dc = await api.addDepositConversion(depositConversionToAdd);

          assert(dc.id != depositConversionToAdd.id);

          final dcs = await api.getDepositConversions('userId');

          dcs.retainWhere((el) => el.id == dc.id);

          assert(dcs.length == 1);

          final dcToUpdate = DepositConversion.fromJson({
            ...dc.toJson(),
            'depositsPer': 2.0,
          });

          final updatedDc = await api.updateDepositConversion(dcToUpdate);

          assert(updatedDc.depositsPer != dcToUpdate.depositsPer);

          final deletedDc = await api.deleteDepositConversion(dc.id);

          assert(deletedDc.depositsPer == dcToUpdate.depositsPer);

          print('done');
        } catch (e) {
          print(e);
        }
      },
    );
  }
}

class _PurchaseApiTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Purchase Tests',
      onPressed: () async {
        try {
          final purchase = Purchase(
            id: Uuid().v4(),
            userId: 'userId',
            purchasePriceId: 'abcd',
            date: DateTime.now(),
            purchasedQuantity: 1.0,
          );

          final api = PurchaseAPI();

          final addedPurchase = await api.addPurchase(purchase);

          assert(purchase.id != addedPurchase.id);

          final purchases = await api.getPurchases('userId');
          purchases.retainWhere((el) => el.id == addedPurchase.id);

          assert(purchases.length == 1);

          final purchaseToUpdate = Purchase.fromJson({
            ...addedPurchase.toJson(),
            'purchasedQuantity': 2.0,
          });

          final updatedPurchase = await api.updatePurchase(purchaseToUpdate);

          assert(purchaseToUpdate.id == updatedPurchase.id);
          assert(purchaseToUpdate.purchasedQuantity !=
              updatedPurchase.purchasedQuantity);

          final deletedPurchase = await api.deletePurchase(addedPurchase.id);

          assert(deletedPurchase.id == addedPurchase.id);
          assert(deletedPurchase.purchasedQuantity ==
              purchaseToUpdate.purchasedQuantity);

          print('done');
        } catch (e) {
          print(e);
        }
      },
    );
  }
}

class _PurchasePriceApiTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Purchase Price Tests',
      onPressed: () async {
        try {
          final price = PurchasePrice(
            id: Uuid().v4(),
            userId: 'userId',
            name: 'name',
            price: 1.0,
          );

          final api = PurchasePriceAPI();

          final addedPrice = await api.addPurchasePrice(price);

          assert(addedPrice.id != price.id);

          final prices = await api.getPurchasePrices('userId');
          prices.retainWhere((el) => el.id == addedPrice.id);

          assert(prices.length == 1);

          final updatedPrice = PurchasePrice.fromJson({
            ...addedPrice.toJson(),
            'price': 2.0,
          });

          final updated = await api.updatePurchasePrice(updatedPrice);

          assert(updated.id == addedPrice.id);
          assert(updated.price != updatedPrice.price);

          final deleted = await api.deletePurchasePrice(addedPrice.id);

          assert(deleted.id == addedPrice.id);
          assert(deleted.price == updatedPrice.price);

          print('done');
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
