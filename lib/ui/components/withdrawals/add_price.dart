import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:provider/provider.dart';

class AddPurchasePriceForm extends StatefulWidget {
  @override
  State createState() => AddPurchasePriceFormState();
}

class AddPurchasePriceFormState extends State<AddPurchasePriceForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  get nameIsValid => nameController.text.isNotEmpty;
  get priceIsValid {
    final parsedValue = num.tryParse(priceController.text);
    return parsedValue != null && parsedValue > 0;
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalMargin = 20;
    const double verticalMargin = 10;

    final canDeposit = nameIsValid && priceIsValid;

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
              onChanged: (_) => setState(() {}),
              controller: priceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Purchase Price',
              ),
            ),
          ),
          BasicBigTextButton(
            text: 'Add New Deposit Conversion',
            allMargin: 10,
            topPadding: 10,
            bottomPadding: 10,
            disabled: !canDeposit,
            onPressed: addNewPrice,
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

  Future<void> addNewPrice() async {
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
      final price = num.parse(priceController.text);

      final priceToAdd = PurchasePrice.newPrice(
        userId: userId,
        name: name,
        price: price,
      );

      await vbProvider.createPurchasePrice(priceToAdd);

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Adding Purchase Price Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
