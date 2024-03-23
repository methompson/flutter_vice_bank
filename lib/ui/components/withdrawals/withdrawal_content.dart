import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/ui/components/user_header.dart';
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

void openAddPurchasePriceDialog(
  BuildContext context, {
  PurchasePrice? purchasePrice,
}) {
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
          child: AddPurchasePriceForm(
            purchasePrice: purchasePrice,
          ),
        ),
      );
    },
  );
}

class WithDrawalContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserHeader(),
        Expanded(
          child: WithrawalDataContent(),
        ),
      ],
    );
  }
}

class WithrawalDataContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, List<PurchasePrice>>(
      selector: (_, vb) => vb.purchasePrices,
      builder: (_, actions, __) {
        return Selector<ViceBankProvider, List<Purchase>>(
          selector: (_, vb) => vb.purchases,
          builder: (context, deposits, __) {
            final items = [
              ...purchasePriceWidgets(context, actions),
              ...purchaseHistoryWidgets(context, deposits),
            ];

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
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
        addAction: () => openAddPurchaseDialog(
          context: context,
          purchasePrice: pr,
        ),
        editAction: () {
          openAddPurchasePriceDialog(context, purchasePrice: pr);
        },
      );
    }).toList();

    return [
      TitleWithIconButton(
        title: 'Purchase Prices',
        iconButton: AddPurchasePriceIconButton(),
      ),
      ...priceWidgets,
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

class AddPurchasePriceIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddIconButton(onPressed: openAddPurchasePriceDialog);
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
}
