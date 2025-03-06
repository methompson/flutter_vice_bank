import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:provider/provider.dart';

class AddPurchasePriceForm extends StatefulWidget {
  final PurchasePrice? purchasePrice;

  AddPurchasePriceForm({this.purchasePrice});

  @override
  State createState() => AddPurchasePriceFormState();
}

class AddPurchasePriceFormState extends State<AddPurchasePriceForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool get nameIsValid => nameController.text.isNotEmpty;
  bool get priceIsValid {
    final parsedValue = num.tryParse(priceController.text);
    return parsedValue != null && parsedValue > 0;
  }

  bool get canDeposit => nameIsValid && priceIsValid;

  @override
  void initState() {
    super.initState();

    final price = widget.purchasePrice;

    if (price != null) {
      nameController.text = price.name;
      priceController.text = price.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalMargin = 20;
    const double verticalMargin = 10;

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
              keyboardType: TextInputType.number,
              controller: priceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Purchase Price',
              ),
            ),
          ),
          if (widget.purchasePrice == null)
            addPriceButton()
          else
            editPriceButton(),
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

  Widget addPriceButton() {
    return BasicBigTextButton(
      text: 'Add New Price',
      allMargin: 10,
      topPadding: 10,
      bottomPadding: 10,
      disabled: !canDeposit,
      onPressed: addNewPrice,
    );
  }

  Widget editPriceButton() {
    return BasicBigTextButton(
      text: 'Update Price',
      allMargin: 10,
      topPadding: 10,
      bottomPadding: 10,
      disabled: !canDeposit,
      onPressed: editPrice,
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
      LoadingScreenData(message: 'Adding Price...'),
    );

    try {
      final userId = currentUser.id;
      final name = nameController.text;
      final price = num.parse(priceController.text);

      final priceToAdd = PurchasePrice.newPrice(
        vbUserId: userId,
        name: name,
        price: price,
      );

      await vbProvider.createPurchasePrice(priceToAdd);

      msgProvider.showSuccessSnackbar('Price added');

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Adding Purchase Price Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }

  Future<void> editPrice() async {
    final msgProvider = context.read<MessagingProvider>();
    final vbProvider = context.read<ViceBankProvider>();

    final purchasePrice = widget.purchasePrice;

    if (purchasePrice == null) {
      msgProvider.showErrorSnackbar(
          'No price selected. Select a Vice Bank User First.');
      return;
    }

    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Updating Price...'),
    );

    try {
      final name = nameController.text;
      final price = num.parse(priceController.text);

      final priceToUpdate = PurchasePrice.fromJson({
        ...purchasePrice.toJson(),
        'name': name,
        'price': price,
      });

      await vbProvider.updatePurchasePrice(priceToUpdate);

      msgProvider.showSuccessSnackbar('Price updated');

      final c = context;
      if (c.mounted) {
        Navigator.pop(c);
      }
    } catch (e) {
      msgProvider.showErrorSnackbar('Updating Purchase Price Failed: $e');
    }

    msgProvider.clearLoadingScreen();
  }
}
