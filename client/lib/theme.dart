import 'package:flutter/material.dart';

final colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal);

final themeData = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  // textTheme: TextTheme(
  //
  // ),
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(),
  ),
);
