import 'package:flutter/material.dart';

class AppTheme {

  final Color colorScheme;

  AppTheme({required this.colorScheme,});


  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: colorScheme,
  );
}