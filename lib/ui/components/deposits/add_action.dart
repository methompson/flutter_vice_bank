import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';

class AddActionForm extends StatefulWidget {
  final VBAction? action;

  AddActionForm({
    this.action,
  });

  @override
  State<AddActionForm> createState() => AddActionFormState();
}

class _CommonMarginContainer extends StatelessWidget {
  final Widget child;

  _CommonMarginContainer(this.child);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: child,
    );
  }
}

class AddActionFormState extends State<AddActionForm> {
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

  bool get canSaveAction =>
      nameIsValid &&
      rateIsValid &&
      depositsPerIsValid &&
      tokensPerIsValid &&
      minDepositIsValid;

  Widget get addActionButton {
    return BasicBigTextButton(
      text: 'Add New Action',
      allMargin: 10,
      topPadding: 10,
      bottomPadding: 10,
      disabled: !canSaveAction,
      onPressed: addNewAction,
    );
  }

  Widget get editActionButton {
    return BasicBigTextButton(
      text: 'Update Action',
      allMargin: 10,
      topPadding: 10,
      bottomPadding: 10,
      disabled: !canSaveAction,
      onPressed: editAction,
    );
  }

  @override
  void initState() {
    super.initState();

    final action = widget.action;

    if (action != null) {
      nameController.text = action.name;
      unitController.text = action.conversionUnit;
      depositsPerController.text = action.depositsPer.toString();
      tokensPerController.text = action.tokensPer.toString();
      minDepositController.text = action.minDeposit.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _CommonMarginContainer(
            TextField(
              onChanged: (_) => setState(() {}),
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Name',
              ),
            ),
          ),
          _CommonMarginContainer(
            TextField(
              controller: unitController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Unit of Measure (e.g. minutes)',
              ),
            ),
          ),
          _CommonMarginContainer(
            TextField(
              controller: depositsPerController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'How much you must deposit',
              ),
            ),
          ),
          _CommonMarginContainer(
            TextField(
              controller: tokensPerController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'How many tokens you get',
              ),
            ),
          ),
          _CommonMarginContainer(
            TextField(
              controller: minDepositController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Minimum Deposit (optional)',
              ),
            ),
          ),
          widget.action == null ? addActionButton : editActionButton,
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

  Future<void> addNewAction() async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final currentUser = vbProvider.currentUser;

    if (currentUser == null) {
      msgProvider.showErrorSnackbar(
          'No user selected. Select a Vice Bank User First.');
      return;
    }

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Adding Action...'),
    );

    try {
      final userId = currentUser.id;
      final name = nameController.text;
      final conversionUnit = unitController.text;
      final depositsPer = num.parse(depositsPerController.text);
      final tokensPer = num.parse(tokensPerController.text);
      final minDeposit = num.tryParse(minDepositController.text) ?? 0;

      final newAction = VBAction.newAction(
        vbUserId: userId,
        name: name.trim(),
        conversionUnit: conversionUnit.trim(),
        depositsPer: depositsPer,
        tokensPer: tokensPer,
        minDeposit: minDeposit,
      );

      await vbProvider.createAction(newAction);

      msgProvider.showSuccessSnackbar('Action added');

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Adding Action Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }

  Future<void> editAction() async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final currentAction = widget.action;

    if (currentAction == null) {
      msgProvider.showErrorSnackbar('No task selected. Try Again.');
      return;
    }

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Updating Action...'),
    );

    try {
      final name = nameController.text;
      final conversionUnit = unitController.text;
      final depositsPer = num.parse(depositsPerController.text);
      final tokensPer = num.parse(tokensPerController.text);
      final minDeposit = num.tryParse(minDepositController.text) ?? 0;

      final updatedAction = VBAction.fromJson({
        ...currentAction.toJson(),
        'name': name.trim(),
        'conversionUnit': conversionUnit.trim(),
        'depositsPer': depositsPer,
        'tokensPer': tokensPer,
        'minDeposit': minDeposit,
      });

      await vbProvider.updateAction(updatedAction);

      msgProvider.showSuccessSnackbar('Action Updated');

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Updating Action Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
