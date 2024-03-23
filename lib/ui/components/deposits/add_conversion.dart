import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';

class AddDepositConversionForm extends StatefulWidget {
  @override
  State<AddDepositConversionForm> createState() =>
      AddDepositConversionFormState();
}

class AddDepositConversionFormState extends State<AddDepositConversionForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController depositsPerController = TextEditingController();
  final TextEditingController tokensPerController = TextEditingController();
  final TextEditingController minDepositController = TextEditingController();

  get nameIsValid => nameController.text.isNotEmpty;
  get rateIsValid => unitController.text.isNotEmpty;
  get depositsPerIsValid {
    final parsedValue = num.tryParse(depositsPerController.text);
    return parsedValue != null && parsedValue > 0;
  }

  get tokensPerIsValid {
    final parsedValue = num.tryParse(tokensPerController.text);
    return parsedValue != null && parsedValue > 0;
  }

  get minDepositIsValid {
    if (minDepositController.text.isEmpty) return true;

    final parsedValue = num.tryParse(minDepositController.text);
    return parsedValue != null && parsedValue > 0;
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalMargin = 20;
    const double verticalMargin = 10;

    final canDeposit = nameIsValid &&
        rateIsValid &&
        depositsPerIsValid &&
        tokensPerIsValid &&
        minDepositIsValid;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: TextField(
              onChanged: (_) => setState(() {}),
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Name',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: TextField(
              controller: unitController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Unit of Measure (e.g. minutes)',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: TextField(
              controller: depositsPerController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText:
                    'Deposits Per (How much of the rate you need to accomplish)',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: TextField(
              controller: tokensPerController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Tokens Per (How many tokens you get for the rate)',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: TextField(
              controller: minDepositController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Minimum Deposit (optional)',
              ),
            ),
          ),
          BasicBigTextButton(
            text: 'Add New Deposit Conversion',
            allMargin: 10,
            topPadding: 10,
            bottomPadding: 10,
            disabled: !canDeposit,
            onPressed: addNewConversion,
          ),
          BasicBigTextButton(
            text: 'Cancel',
            allMargin: 10,
            topPadding: 10,
            bottomPadding: 10,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> addNewConversion() async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final currentUser = vbProvider.currentUser;

    if (currentUser == null) {
      msgProvider.showErrorSnackbar(
          'No user selected. Select a Vice Bank User First.');
      return;
    }

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Adding Deposit Conversion...'),
    );

    try {
      final userId = currentUser.id;
      final name = nameController.text;
      final conversionUnit = unitController.text;
      final depositsPer = num.parse(depositsPerController.text);
      final tokensPer = num.parse(tokensPerController.text);
      final minDeposit = num.tryParse(minDepositController.text) ?? 0;

      final newConversion = VBAction.newAction(
        vbUserId: userId,
        name: name.trim(),
        conversionUnit: conversionUnit.trim(),
        depositsPer: depositsPer,
        tokensPer: tokensPer,
        minDeposit: minDeposit,
      );

      await vbProvider.createAction(newConversion);

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Adding Deposit Conversion Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
