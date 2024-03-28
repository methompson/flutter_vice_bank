import 'package:flutter/material.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:provider/provider.dart';

class UserHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vbProvider = context.watch<ViceBankProvider>();

    final user = vbProvider.currentUser;

    if (user == null) {
      return Container();
    }

    final unit = user.currentTokens == 1 ? 'token' : 'tokens';

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListTile(
        title: Text(
          user.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        subtitle: Text('${user.currentTokens.toStringAsFixed(2)} $unit'),
      ),
    );
  }
}
