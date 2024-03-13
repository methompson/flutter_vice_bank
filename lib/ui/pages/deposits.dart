import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/deposit_conversion.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';
import 'package:provider/provider.dart';

class DepositsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CenteredFullSizeContainer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Deposit Conversions',
              style: Theme.of(context).copyWith().textTheme.bodyLarge,
            ),
            DepositConversionList(),
            Text(
              'Deposit History',
              style: Theme.of(context).copyWith().textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class DepositConversionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, List<DepositConversion>>(
      selector: (_, provider) => provider.depositConversions,
      builder: (context, depositConversions, __) {
        if (depositConversions.isEmpty) {
          return Column(
            children: [
              Text('No deposit conversions'),
              BasicBigTextButton(
                text: 'Add a New Deposit Conversion',
                onPressed: () {
                  openAddDepositConversionDialog(context);
                },
              ),
            ],
          );
        }

        return ListView.builder(
          itemCount: depositConversions.length,
          itemBuilder: (context, index) {
            final depositConversion = depositConversions[index];
            return ListTile(
              title: Text(depositConversion.name),
              // subtitle: Text(depositConversion.date.toString()),
            );
          },
        );
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

class AddDepositConversionForm extends StatefulWidget {
  @override
  State<AddDepositConversionForm> createState() =>
      AddDepositConversionFormState();
}

class AddDepositConversionFormState extends State<AddDepositConversionForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController depositsPerController = TextEditingController();
  final TextEditingController tokensPerController = TextEditingController();
  final TextEditingController minDepositController = TextEditingController();

  get nameIsValid => nameController.text.isNotEmpty;
  get rateIsValid => rateController.text.isNotEmpty;
  get depositsPerIsValid {
    final parsedValue = double.tryParse(depositsPerController.text);
    return parsedValue != null && parsedValue > 0;
  }

  get tokensPerIsValid {
    final parsedValue = double.tryParse(tokensPerController.text);
    return parsedValue != null && parsedValue > 0;
  }

  get minDepositIsValid {
    if (minDepositController.text.isEmpty) return true;

    final parsedValue = double.tryParse(minDepositController.text);
    return parsedValue != null && parsedValue > 0;
  }

  @override
  Widget build(BuildContext context) {
    print('building');
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
                labelText: 'Conversion Name',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: verticalMargin,
            ),
            child: TextField(
              controller: rateController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'Rate (e.g. minutes)',
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
            onPressed: () {},
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
}
