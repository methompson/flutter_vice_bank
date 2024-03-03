import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
        CupertinoTextField(
          controller: _emailController,
          placeholder: 'Email',
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
        ),
        CupertinoTextField(
          controller: _passwordController,
          placeholder: 'Password',
          obscureText: true,
        ),
        CupertinoButton(
          onPressed: loginUser,
          child: const Text('Login'),
        ),
        CupertinoButton(
          onPressed: logUserOut,
          child: const Text('Logout'),
        ),
      ],
    );
  }

  logUserOut() async {
    await FirebaseAuth.instance.signOut();
    print('Logged out');
  }

  loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Logged in');
      print('${credential.user?.email}');
    } catch (e) {
      print('Error logging in: $e');
    }
  }
}
