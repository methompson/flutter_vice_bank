import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/deposit_conversion.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/deposits/deposit_conversion_card.dart';

class AddDepositForm extends StatefulWidget {
  final DepositConversion depositConversion;

  AddDepositForm({required this.depositConversion});

  @override
  State<AddDepositForm> createState() => AddDepositFormState();
}

class AddDepositFormState extends State<AddDepositForm> {
  final TextEditingController depositController = TextEditingController();

  bool get canDeposit {
    final number = deposit;
    if (number == null) return false;
    return number > 0 && number >= widget.depositConversion.minDeposit;
  }

  num? get deposit {
    return num.tryParse(depositController.text);
  }

  @override
  Widget build(BuildContext context) {
    const double verticalMargin = 10;

    final dc = widget.depositConversion;

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
            DepositConversionCard(depositConversion: dc),
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
        vbUserId: widget.depositConversion.vbUserId,
        depositQuantity: num.parse(depositController.text),
        conversionRate: widget.depositConversion.conversionRate,
        depositConversionName: widget.depositConversion.name,
        conversionUnit: widget.depositConversion.conversionUnit,
      );

      await vbProvider.addDeposit(depositToAdd);

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
