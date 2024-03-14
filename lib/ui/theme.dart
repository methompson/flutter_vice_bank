import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final seedColor = Colors.red;
// final seedColor = Colors.red[900]!;

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: seedColor,
);

final darkColorScheme = ColorScheme.fromSeed(
  seedColor: seedColor,
  brightness: Brightness.dark,
);

final commonFilledButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  ),
);

const bodyLargeSize = 20.0;
const bodyMediumSize = 16.0;
const bodySmallSize = 12.0;

const themeFontWeight = FontWeight.w500;

final lightTextTheme = ThemeData.light().textTheme.copyWith(
      bodyLarge: TextStyle(
        fontSize: bodyLargeSize,
        fontWeight: themeFontWeight,
        color: lightColorScheme.onBackground,
      ),
      bodyMedium: TextStyle(
        fontSize: bodyMediumSize,
        // fontWeight: themeFontWeight,
        color: lightColorScheme.onBackground,
      ),
      bodySmall: TextStyle(
        fontSize: bodySmallSize,
        // fontWeight: themeFontWeight,
        color: lightColorScheme.onBackground,
      ),
    );

final darkTextTheme = ThemeData.dark().textTheme.copyWith(
      bodyLarge: TextStyle(
        fontSize: bodyLargeSize,
        fontWeight: themeFontWeight,
        color: darkColorScheme.onBackground,
      ),
      bodyMedium: TextStyle(
        fontSize: bodyMediumSize,
        // fontWeight: themeFontWeight,
        color: darkColorScheme.onBackground,
      ),
      bodySmall: TextStyle(
        fontSize: bodySmallSize,
        // fontWeight: themeFontWeight,
        color: darkColorScheme.onBackground,
      ),
    );

final lightTheme = ThemeData.light().copyWith(
  cupertinoOverrideTheme: CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: lightColorScheme.primary,
    scaffoldBackgroundColor: lightColorScheme.background,
  ),
  colorScheme: lightColorScheme,
  filledButtonTheme: FilledButtonThemeData(
    style: commonFilledButtonStyle,
  ),
  textTheme: lightTextTheme,
);

final darkTheme = ThemeData.dark().copyWith(
  cupertinoOverrideTheme: CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: darkColorScheme.primary,
    scaffoldBackgroundColor: lightColorScheme.background,
  ),
  colorScheme: darkColorScheme,
  filledButtonTheme: FilledButtonThemeData(
    style: commonFilledButtonStyle,
  ),
  textTheme: darkTextTheme,
);
