import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:flutter_vice_bank/global_state/vice_bank_provider.dart';
import 'package:flutter_vice_bank/ui/components/buttons.dart';

import 'package:flutter_vice_bank/ui/components/page_container.dart';

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
            child: TextField(
              onChanged: (_) => setState(() {}),
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                labelText: 'User Name',
              ),
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
          ),
        ],
      ),
    );
  }
}
