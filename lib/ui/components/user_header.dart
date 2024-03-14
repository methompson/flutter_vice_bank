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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
            Text('${user.currentTokens} $unit'),
          ],
        ),
      ),
    );
  }
}
