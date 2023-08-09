import 'package:flutter/material.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/login/presentation/views/login_view.dart';
import 'package:histouric_web/login/presentation/views/register_view.dart';

import 'config/navigation/router.dart';
import 'config/theme/app_theme.dart';
import 'login/presentation/screens/screens.dart';

void main() {
  FluroRouterWrapper.configureRoutes();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = AppTheme(colorScheme: const Color(0xff0266C8));

    return MaterialApp(
      title: 'Histouric Web',
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
      initialRoute: FluroRouterWrapper.rootRoute,
      onGenerateRoute: FluroRouterWrapper.router.generator,
      navigatorKey: NavigationService.navigatorKey,
      builder: (context, child) {
        // return Scaffold(body: child!);
        return AuthScreen(child: child!);
      },
    );
  }
}
