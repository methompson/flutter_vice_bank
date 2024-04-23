import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/users/create_user_form.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';

class SelectUser extends StatelessWidget {
  final bool inModal;
  SelectUser({
    this.inModal = true,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<ViceBankProvider, List<ViceBankUser>>(
      selector: (_, provider) => provider.users,
      builder: (context, users, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (users.isEmpty)
              Text('No Users Available')
            else
              UsersList(inModal: inModal),
            BasicBigTextButton(
              text: 'Add a New User',
              topMargin: 20,
              allPadding: 10,
              onPressed: () {
                openCreateUserDialog(context);
              },
            ),
            if (users.isNotEmpty)
              BasicBigTextButton(
                text: 'Deselect User',
                topMargin: 20,
                allPadding: 10,
                onPressed: () {
                  context.read<ViceBankProvider>().selectUser(null);
                  if (inModal) {
                    Navigator.pop(context);
                  }
                },
              ),
          ],
        );
      },
    );
  }

  void openCreateUserDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(body: CreateUserForm());
      },
    );
  }
}

class UsersList extends StatelessWidget {
  final bool inModal;

  UsersList({
    this.inModal = true,
  });

  @override
  Widget build(BuildContext context) {
    final vbProvider = context.read<ViceBankProvider>();
    final users = vbProvider.users;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text('Select a User'),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            final unit = user.currentTokens == 1 ? 'token' : 'tokens';

            return Card(
              child: ListTile(
                title: Text(user.name),
                subtitle:
                    Text('${user.currentTokens.toStringAsFixed(2)} $unit'),
                onTap: () {
                  vbProvider.selectUser(user.id);
                  if (inModal) {
                    Navigator.pop(context);
                  }
                },
              ),
            );

            // return Text('User: ${user.name}');
          },
        ),
      ],
    );
  }
}
