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
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:uuid/uuid.dart';

class DebugButtons extends StatelessWidget {
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

class _ViceBankUsersTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DebugButton(
      buttonText: 'Vice Bank Users Tests',
      onPressed: () async {
        final msgProvider = context.read<MessagingProvider>();
        try {
          final vbp = context.read<ViceBankProvider>();

          final userToAdd = ViceBankUser.newUser(
            name: 'Mat Thompson',
            currentTokens: 0,
          );

          final apis = ViceBankUserAPI();

          final addedUser = await apis.addViceBankUser(userToAdd);

          assert(addedUser.id != userToAdd.id);

          await vbp.getViceBankUsers();

          final users = vbp.users;
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

          msgProvider.showSuccessSnackbar('Vice Bank User Tests Passed');
        } catch (e) {
          msgProvider.showErrorSnackbar(e.toString());
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
        final msgProvider = context.read<MessagingProvider>();

        try {
          final userToAdd = ViceBankUser.newUser(
            name: 'Mat Thompson',
            currentTokens: 0,
          );

          final vbApi = ViceBankUserAPI();

          final addedUser = await vbApi.addViceBankUser(userToAdd);

          final depositToAdd = Deposit.newDeposit(
            vbUserId: addedUser.id,
            depositQuantity: 1.0,
            conversionRate: 1.0,
            depositConversionName: 'depositConversionName',
            conversionUnit: 'minutes',
          );

          final apis = DepositAPI();

          final addedDeposit = (await apis.addDeposit(depositToAdd)).deposit;

          assert(addedDeposit.id != depositToAdd.id);

          final deposits = await apis.getDeposits(addedUser.id);

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

          msgProvider.showSuccessSnackbar('Deposit Tests Passed');

          await vbApi.deleteViceBankUser(addedUser.id);
        } catch (e) {
          msgProvider.showErrorSnackbar(e.toString());
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
        final msgProvider = context.read<MessagingProvider>();

        try {
          final depositConversionToAdd = DepositConversion.newConversion(
            vbUserId: 'userId',
            name: 'name',
            conversionUnit: 'conversionUnit',
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

          msgProvider.showSuccessSnackbar('Deposit Conversion Tests Passed');
        } catch (e) {
          msgProvider.showErrorSnackbar(e.toString());
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
        final msgProvider = context.read<MessagingProvider>();

        try {
          final userToAdd = ViceBankUser.newUser(
            name: 'Mat Thompson',
            currentTokens: 0,
          );

          final vbApi = ViceBankUserAPI();

          final addedUser = await vbApi.addViceBankUser(userToAdd);

          final depositToAdd = Deposit.newDeposit(
            vbUserId: addedUser.id,
            depositQuantity: 1.0,
            conversionRate: 1.0,
            depositConversionName: 'depositConversionName',
            conversionUnit: 'minutes',
          );

          await DepositAPI().addDeposit(depositToAdd);

          final purchase = Purchase.newPurchase(
            vbUserId: addedUser.id,
            purchasePriceId: 'abcd',
            purchasedQuantity: 1,
          );

          final api = PurchaseAPI();

          final addedPurchase = (await api.addPurchase(purchase)).purchase;

          assert(purchase.id != addedPurchase.id);

          final purchases = await api.getPurchases(addedUser.id);
          purchases.retainWhere((el) => el.id == addedPurchase.id);

          assert(purchases.length == 1);

          final purchaseToUpdate = Purchase.fromJson({
            ...addedPurchase.toJson(),
            'purchasedQuantity': 2,
          });

          final updatedPurchase = await api.updatePurchase(purchaseToUpdate);

          assert(purchaseToUpdate.id == updatedPurchase.id);
          assert(purchaseToUpdate.purchasedQuantity !=
              updatedPurchase.purchasedQuantity);

          final deletedPurchase = await api.deletePurchase(addedPurchase.id);

          assert(deletedPurchase.id == addedPurchase.id);
          assert(deletedPurchase.purchasedQuantity ==
              purchaseToUpdate.purchasedQuantity);

          msgProvider.showSuccessSnackbar('Purchase Tests Passed');

          await vbApi.deleteViceBankUser(addedUser.id);
        } catch (e) {
          msgProvider.showErrorSnackbar(e.toString());
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
        final msgProvider = context.read<MessagingProvider>();

        try {
          final price = PurchasePrice.newPrice(
            vbUserId: 'userId',
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

          msgProvider.showSuccessSnackbar('Purchase Price Tests Passed');
        } catch (e) {
          msgProvider.showErrorSnackbar(e.toString());
        }
      },
    );
  }
}