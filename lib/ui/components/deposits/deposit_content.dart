import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/deposit_conversion.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';

import 'package:flutter_vice_bank/ui/components/deposits/add_conversion.dart';
import 'package:flutter_vice_bank/ui/components/deposits/add_deposit.dart';
import 'package:flutter_vice_bank/ui/components/deposits/deposit_card.dart';
import 'package:flutter_vice_bank/ui/components/deposits/deposit_conversion_card.dart';
import 'package:flutter_vice_bank/ui/components/title_widget.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';

class DepositsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, List<DepositConversion>>(
      selector: (_, vb) => vb.depositConversions,
      builder: (_, depositConversions, __) {
        return Selector<ViceBankProvider, List<Deposit>>(
          selector: (_, vb) => vb.deposits,
          builder: (context, deposits, __) {
            final items = [
              ...depositConversionWidgets(context, depositConversions),
              ...depositHistoryWidgets(context, deposits),
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

  List<Widget> depositConversionWidgets(
    BuildContext context,
    List<DepositConversion> conversions,
  ) {
    if (conversions.isEmpty) {
      return [
        TitleWidget(title: 'No Deposit Conversions'),
        AddDepositConversionButton(),
      ];
    }

    final List<Widget> conversionWidgets = conversions.map((con) {
      return DepositConversionCard(
        depositConversion: con,
        onTap: () => openAddDepositDialog(
          context: context,
          depositConversion: con,
        ),
      );
    }).toList();

    return [
      TitleWidget(title: 'Deposit Conversions'),
      ...conversionWidgets,
      AddDepositConversionButton(),
    ];
  }

  List<Widget> depositHistoryWidgets(
    BuildContext context,
    List<Deposit> deposits,
  ) {
    final List<Widget> depositWidgets = deposits.map((deposit) {
      return DepositCard(deposit: deposit);
    }).toList();

    return [
      TitleWidget(title: 'Deposit History'),
      ...depositWidgets,
    ];
  }

  void openAddDepositDialog({
    required BuildContext context,
    required DepositConversion depositConversion,
  }) {
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
            child: AddDepositForm(
              depositConversion: depositConversion,
            ),
          ),
        );
      },
    );
  }
}

class AddDepositConversionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicBigTextButton(
      topMargin: 20,
      bottomMargin: 10,
      allPadding: 10,
      text: 'Add a New Deposit Conversion',
      onPressed: () {
        openAddDepositConversionDialog(context);
      },
    );
  }

  void openAddDepositConversionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(
          body: FullSizeContainer(
            child: AddDepositConversionForm(),
          ),
        );
      },
    );
  }
}
