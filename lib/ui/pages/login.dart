import 'package:flutter/cupertino.dart';
import 'package:flutter_action_bank/ui/components/loadable.dart';

import 'package:flutter_action_bank/ui/components/login_fields.dart';
import 'package:flutter_action_bank/ui/components/page_container.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: LoginFields(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Loadable(Login());
  }
}
