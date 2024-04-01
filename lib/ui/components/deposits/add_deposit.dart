import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/action.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/deposits/action_card.dart';

class AddDepositForm extends StatefulWidget {
  final VBAction action;

  AddDepositForm({required this.action});

  @override
  State<AddDepositForm> createState() => AddDepositFormState();
}

class AddDepositFormState extends State<AddDepositForm> {
  final TextEditingController depositController = TextEditingController();

  bool get canDeposit {
    final number = deposit;
    if (number == null) return false;
    return number > 0 && number >= widget.action.minDeposit;
  }

  num? get deposit {
    return num.tryParse(depositController.text);
  }

  @override
  Widget build(BuildContext context) {
    const double verticalMargin = 10;

    final dc = widget.action;

    final d = deposit;

    var tokens = 'N/A';

    if (d != null) {
      final tokenVal = d / dc.depositsPer * dc.tokensPer;
      tokens = tokenVal.toStringAsFixed(2);
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: verticalMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ActionCard(action: dc),
            Container(
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              child: Text(
                'Tokens: $tokens',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
            ),
            TextField(
              onChanged: (_) => setState(() {}),
              controller: depositController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: dc.conversionUnit,
              ),
            ),
            BasicBigTextButton(
              text: 'Deposit',
              topMargin: 10,
              topPadding: 10,
              bottomPadding: 10,
              disabled: !canDeposit,
              onPressed: addDeposit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addDeposit() async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Adding Deposit...'),
    );

    try {
      final depositToAdd = Deposit.newDeposit(
        vbUserId: widget.action.vbUserId,
        depositQuantity: num.parse(depositController.text),
        conversionRate: widget.action.conversionRate,
        action: widget.action,
        conversionUnit: widget.action.conversionUnit,
      );

      await vbProvider.addDepositTask(depositToAdd);

      msgProvider.showSuccessSnackbar('Deposit Added');

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Adding Deposit Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
