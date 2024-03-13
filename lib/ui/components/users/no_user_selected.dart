import 'package:flutter/material.dart';

import 'package:flutter_vice_bank/ui/components/buttons.dart';
import 'package:flutter_vice_bank/ui/components/page_container.dart';
import 'package:flutter_vice_bank/ui/components/users/user_selection.dart';

class NoUserSelected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ThemeColors(),
        Text(
          'No User Selected',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        SelectUser(inModal: false),
      ],
    );
  }
}

class SelectAUserButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicBigTextButton(
      text: 'Select a User',
      topMargin: 10,
      allPadding: 15,
      onPressed: () => openSelectUserDialog(context),
    );
  }

  void openSelectUserDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      // isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Scaffold(body: FullSizeContainer(child: SelectUser()));
        // return CreateUserForm();
      },
    );
  }
}
