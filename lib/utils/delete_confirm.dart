import 'package:flutter/material.dart';

Future<bool> confirmDelete({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  final result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Ok'),
          ),
        ],
      );
    },
  );

  return result == true;
}
