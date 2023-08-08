import 'package:flutter/material.dart';

import 'config/theme/app_theme.dart';
import 'login/presentation/screens/screens.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    AppTheme appTheme = AppTheme(colorScheme: const Color(0xff009e89));

    return MaterialApp(
      title: 'Histouric Web',
      theme: appTheme.getTheme(),
      home: const LoginPage(),
    );
  }
}
