import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/withdrawals/price_card.dart';
import 'package:provider/provider.dart';

class AddPurchaseForm extends StatefulWidget {
  final PurchasePrice purchasePrice;
  final ViceBankUser currentUser;

  AddPurchaseForm({required this.purchasePrice, required this.currentUser});

  @override
  State createState() => AddPurchaseFormState();
}

class AddPurchaseFormState extends State<AddPurchaseForm> {
  final TextEditingController purchaseController = TextEditingController();
  bool hasEdited = false;

  String get errorMessage {
    final numParse = num.tryParse(purchaseController.text);
    if (numParse == null) return 'Not a valid number';

    final number = price;
    if (number == null) return 'Must be a whole number';

    if (number <= 0) return 'Number must be greater than 0';

    if (number > widget.currentUser.currentTokens) return 'Not enough tokens';

    return '';
  }

  bool get canPurchase {
    return errorMessage.isEmpty;
  }

  int? get price {
    return int.tryParse(purchaseController.text);
  }

  @override
  Widget build(BuildContext context) {
    const double verticalMargin = 10;

    final pp = widget.purchasePrice;

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: verticalMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PurchasePriceCard(purchasePrice: pp),
            Container(
              margin: EdgeInsets.symmetric(vertical: verticalMargin),
              child: Text(
                'Tokens Available: ${widget.currentUser.currentTokens.toStringAsFixed(2)}',
              ),
            ),
            TextField(
              onChanged: (_) {
                hasEdited = true;
                setState(() {});
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: purchaseController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Quantity',
              ),
            ),
            BasicBigTextButton(
              text: 'Purchase',
              topMargin: 10,
              topPadding: 10,
              bottomPadding: 10,
              disabled: !canPurchase,
              onPressed: purchase,
            ),
            if (!canPurchase && hasEdited)
              Container(
                margin: EdgeInsets.symmetric(vertical: verticalMargin),
                child: Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                  textAlign: TextAlign.start,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> purchase() async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Adding Purchase...'),
    );

    try {
      final purchaseToAdd = Purchase.newPurchase(
        purchasePrice: widget.purchasePrice,
        purchasedQuantity: int.parse(purchaseController.text),
      );

      await vbProvider.addPurchaseTask(purchaseToAdd);

      msgProvider.showSuccessSnackbar('Purchase Added');

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Adding Purchase Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
