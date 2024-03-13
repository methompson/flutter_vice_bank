import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/data_models/vice_bank_user.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';

import 'package:flutter_vice_bank/ui/components/page_container.dart';

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

            return Card(
              child: ListTile(
                title: Text(user.name),
                subtitle: Text('${user.currentTokens} Token(s)'),
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

class CreateUserForm extends StatefulWidget {
  @override
  State<CreateUserForm> createState() => CreateUserFormState();
}

class CreateUserFormState extends State<CreateUserForm> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vbProvider = context.read<ViceBankProvider>();
    final msgProvider = context.read<MessagingProvider>();

    return CenteredFullSizeContainer(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: CupertinoTextField(
              controller: _nameController,
              onChanged: (_) {
                setState(() {});
              },
              placeholder: 'User Name',
            ),
          ),
          BasicBigTextButton(
            disabled: _nameController.text.isEmpty,
            text: 'Add User',
            onPressed: () async {
              msgProvider.setLoadingScreenData(
                  LoadingScreenData(message: 'Saving New User'));

              try {
                await vbProvider.createUser(_nameController.text.trim());

                msgProvider.showSuccessSnackbar('User Created');

                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                msgProvider.showErrorSnackbar('Creating User Failed: $e');
              }

              msgProvider.clearLoadingScreen();
            },
          )
        ],
      ),
    );
  }
}
