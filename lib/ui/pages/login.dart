import 'package:flutter/cupertino.dart';
import 'package:flutter_action_bank/ui/components/login_fields.dart';
import 'package:flutter_action_bank/ui/components/page_container.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Center(
        child: LoginFields(),
      ),
    );
  }
}
