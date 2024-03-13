import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';
import 'package:flutter_vice_bank/ui/components/users/no_user_selected.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, ViceBankUser?>(
      selector: (_, provider) => provider.currentUser,
      builder: (context, currentUser, __) {
        final widget = currentUser == null ? NoUserSelected() : UserPage();
        return CenteredFullSizeContainer(
          child: widget,
        );
      },
    );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NameSection(),
        Expanded(child: WithdrawSection()),
        Expanded(child: DepositSection()),
        SelectAUserButton(),
      ],
    );
  }
}

class NameSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<ViceBankProvider>().currentUser;

    return Container(
      color: Colors.redAccent,
      margin: EdgeInsets.only(top: 30, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentUser?.name}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    '${currentUser?.currentTokens} Token(s)',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WithdrawSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton.tonal(
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.minus,
                          size: 64,
                        ),
                        Text(
                          'Withdraw Tokens',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                    onPressed: () {
                      print('withdraw tokens');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DepositSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton.tonal(
                    child: Column(
                      children: [
                        Icon(
                          CupertinoIcons.add,
                          size: 64,
                        ),
                        Text(
                          'Deposit Tokens',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                    onPressed: () {
                      print('deposit tokens');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
