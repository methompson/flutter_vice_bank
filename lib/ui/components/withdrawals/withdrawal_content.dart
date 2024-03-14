import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/ui/components/withdrawals/purchase_card.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';
import 'package:flutter_vice_bank/ui/components/title_widget.dart';
import 'package:flutter_vice_bank/ui/components/withdrawals/add_price.dart';
import 'package:flutter_vice_bank/ui/components/withdrawals/add_purchase.dart';
import 'package:flutter_vice_bank/ui/components/withdrawals/price_card.dart';

class WithDrawalContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, List<PurchasePrice>>(
      selector: (_, vb) => vb.purchasePrices,
      builder: (_, depositConversions, __) {
        return Selector<ViceBankProvider, List<Purchase>>(
          selector: (_, vb) => vb.purchases,
          builder: (context, deposits, __) {
            final items = [
              ...purchasePriceWidgets(context, depositConversions),
              ...purchaseHistoryWidgets(context, deposits),
            ];

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return items[index];
                },
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> purchasePriceWidgets(
    BuildContext context,
    List<PurchasePrice> prices,
  ) {
    if (prices.isEmpty) {
      return [
        TitleWidget(title: 'No Purchase Prices'),
        AddPurchasePriceButton(),
      ];
    }

    final List<Widget> priceWidgets = prices.map((pr) {
      return PurchasePriceCard(
        purchasePrice: pr,
        onTap: () => openAddPurchaseDialog(
          context: context,
          purchasePrice: pr,
        ),
      );
    }).toList();

    return [
      TitleWidget(title: 'Purchase Prices'),
      ...priceWidgets,
      AddPurchasePriceButton(),
    ];
  }

  List<Widget> purchaseHistoryWidgets(
    BuildContext context,
    List<Purchase> purchases,
  ) {
    final List<Widget> purchaseWidgets = purchases.map((purchase) {
      return PurchaseCard(
        purchase: purchase,
      );
    }).toList();

    return [
      TitleWidget(title: 'Purchase History'),
      ...purchaseWidgets,
    ];
  }

  void openAddPurchaseDialog({
    required BuildContext context,
    required PurchasePrice purchasePrice,
  }) {
    final vb = context.read<ViceBankProvider>();
    final currentUser = vb.currentUser;

    if (currentUser == null) {
      final msgProvider = context.read<MessagingProvider>();
      msgProvider.showErrorSnackbar(
        'No user selected. Select a Vice Bank User First.',
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(
          body: FullSizeContainer(
            child: AddPurchaseForm(
              purchasePrice: purchasePrice,
              currentUser: currentUser,
            ),
          ),
        );
      },
    );
  }
}

class AddPurchasePriceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicBigTextButton(
      topMargin: 20,
      bottomMargin: 10,
      allPadding: 10,
      text: 'Add a New Purchase Price',
      onPressed: () {
        openAddPurchasePriceDialog(context);
      },
    );
  }

  void openAddPurchasePriceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(
          body: FullSizeContainer(
            child: AddPurchasePriceForm(),
          ),
        );
      },
    );
  }
}
