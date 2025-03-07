import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/data_models/deposit.dart';
import 'package:flutter_vice_bank/data_models/purchase.dart';
import 'package:flutter_vice_bank/ui/components/user_header.dart';

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
        final child = currentUser == null ? NoUserSelected() : UserPage();

        return CenteredFullSizeContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [Expanded(child: child)],
          ),
        );
      },
    );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UserHeader(),
        WithdrawSection(),
        DepositSection(),
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
      // margin: EdgeInsets.only(top: 30, bottom: 10),
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
    return Selector<ViceBankProvider, List<Purchase>>(
      selector: (_, vb) => vb.purchases,
      builder: (context, purchases, _) {
        final daysAgo = DateTime.now().subtract(Duration(days: 7));
        final recentPurchases =
            purchases.where((p) => p.date.isAfter(daysAgo)).toList();

        final totalTokensSpent = recentPurchases.fold<num>(
          0,
          (previousValue, purchase) =>
              previousValue + purchase.purchasedQuantity,
        );

        final totalPurchases = recentPurchases.length;

        return Card(
          margin: EdgeInsets.all(20),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Purchases',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Text(
                  'Past Week Purchases:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    '$totalPurchases',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  'Total Tokens Spent:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    '$totalTokensSpent',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DepositSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, List<TaskDeposit>>(
      selector: (_, vb) => vb.taskDeposits,
      builder: (context, taskDeposits, _) {
        return Selector<ViceBankProvider, List<Deposit>>(
          selector: (_, vb) => vb.deposits,
          builder: (context, actionDeposits, _) {
            final daysAgo = DateTime.now().subtract(Duration(days: 7));
            final recentActionDeposits =
                actionDeposits.where((p) => p.date.isAfter(daysAgo)).toList();
            final recentTaskDeposits =
                taskDeposits.where((p) => p.date.isAfter(daysAgo)).toList();

            final recentTaskDepositTokens = recentTaskDeposits.fold<num>(
              0,
              (previousValue, deposit) => previousValue + deposit.tokensEarned,
            );

            final recentActionDepositTokens = actionDeposits.fold<num>(
              0,
              (previousValue, deposit) => previousValue + deposit.tokensEarned,
            );

            final totalTokensEarned =
                recentTaskDepositTokens + recentActionDepositTokens;

            final totalDeposits =
                recentActionDeposits.length + recentTaskDeposits.length;

            return Card(
              margin: EdgeInsets.all(20),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Deposits',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Text(
                      'Past Week Deposits:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        '$totalDeposits',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      'Total Tokens Earned:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        totalTokensEarned.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
