import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/data_models/purchase_price.dart';

class PurchasePriceCard extends StatelessWidget {
  final PurchasePrice purchasePrice;
  final Function()? onTap;

  PurchasePriceCard({required this.purchasePrice, this.onTap});

  @override
  Widget build(BuildContext context) {
    final unit = purchasePrice.price == 1 ? 'token' : 'tokens';
    return Card(
      child: ListTile(
        title: Text(purchasePrice.name),
        onTap: onTap,
        subtitle: Text('Cost: ${purchasePrice.price} $unit'),
      ),
    );
  }
}
