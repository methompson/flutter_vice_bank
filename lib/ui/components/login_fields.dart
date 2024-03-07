import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_vice_bank/data_models/messaging_data.dart';
import 'package:flutter_vice_bank/global_state/messaging_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:flutter_vice_bank/ui/components/buttons.dart';

import 'package:flutter_vice_bank/global_state/authentication_provider.dart';

class LoginFields extends StatefulWidget {
  LoginFields({super.key});

  @override
  State<LoginFields> createState() => LoginFieldsState();
}

class LoginFieldsState extends State<LoginFields> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: CupertinoTextField(
            controller: _emailController,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: CupertinoTextField(
            controller: _passwordController,
            placeholder: 'Password',
            obscureText: true,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: BasicBigTextButton(
            onPressed: loginUser,
            text: 'Login',
          ),
        ),
      ],
    );
  }

  loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final authProvider = context.read<AuthenticationProvider>();
    final msgProvider = context.read<MessagingProvider>();

    print('loading started');
    msgProvider.setLoadingScreenData(
      LoadingScreenData(message: 'Logging in...'),
    );

    try {
      print('signing in');
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('setting authentication');
      final user = FirebaseAuth.instance.currentUser;
      authProvider.setAuthentication(user);

      if (mounted) {
        print('going to home');
        context.go('/home');
      }
    } catch (e) {
      print('Error logging in: $e');
      msgProvider.showErrorSnackbar(
        'Error logging in: $e',
      );
    }

    print('about to clear loading');
    msgProvider.clearLoadingScreen();
    print('loading cleared');
  }
}
