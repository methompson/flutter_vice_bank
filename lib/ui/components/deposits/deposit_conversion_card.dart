import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/deposit_conversion.dart';

class DepositConversionCard extends StatelessWidget {
  final DepositConversion depositConversion;
  final Function()? onTap;

  DepositConversionCard({required this.depositConversion, this.onTap});

  @override
  Widget build(BuildContext context) {
    final minDeposit = depositConversion.minDeposit;

    final minDepositWidget = minDeposit <= 0
        ? Container()
        : Text('Min Deposit: $minDeposit ${depositConversion.conversionUnit}');

    final depositTxt =
        '${depositConversion.depositsPer} ${depositConversion.conversionUnit} for ${depositConversion.tokensPer} Token(s)';

    return Card(
      child: ListTile(
        title: Text(depositConversion.name),
        onTap: onTap,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(depositTxt),
            minDepositWidget,
          ],
        ),
      ),
    );
  }
}
