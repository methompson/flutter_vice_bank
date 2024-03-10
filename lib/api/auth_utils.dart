import 'package:firebase_auth/firebase_auth.dart';

Future<String> getAuthorizationToken() async {
  final authInstance = FirebaseAuth.instance;
  final token = await authInstance.currentUser?.getIdToken();

  if (token == null) {
    throw Exception('No token found');
  }

  return token;
}
