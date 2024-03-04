import 'package:flutter/material.dart';

final commonFilledButtonTheme = ButtonStyle(
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  ),
  backgroundColor: MaterialStateProperty.all(Colors.red),
  foregroundColor: MaterialStateProperty.all(Colors.white),
  textStyle: MaterialStateProperty.all(
    TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    ),
  ),
);

final lightTheme = ThemeData.light().copyWith(
  filledButtonTheme: FilledButtonThemeData(
    style: commonFilledButtonTheme,
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  filledButtonTheme: FilledButtonThemeData(
    style: commonFilledButtonTheme.copyWith(
      foregroundColor: MaterialStateProperty.all(Colors.black),
    ),
  ),
);
