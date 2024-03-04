import 'package:flutter/material.dart';

SnackBar _baseSnackBar(String text, Color color, {Duration? duration}) {
  final dur = duration ?? Duration(seconds: 10);
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
    backgroundColor: color,
    showCloseIcon: true,
    duration: dur,
  );
}

SnackBar makeInfoSnackBar(
  String text, {
  Duration? duration,
}) {
  return _baseSnackBar(
    text,
    Colors.blue,
    duration: duration,
  );
}

SnackBar makeErrorSnackBar(
  String text, {
  Duration? duration,
}) {
  final dur = duration ?? Duration(seconds: 60);
  return _baseSnackBar(
    text,
    Colors.red,
    duration: dur,
  );
}

SnackBar makeSuccessSnackBar(
  String text, {
  Duration? duration,
}) {
  return _baseSnackBar(
    text,
    Colors.green[400] ?? Colors.green,
    duration: duration,
  );
}
