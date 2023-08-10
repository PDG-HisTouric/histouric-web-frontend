import 'package:flutter/material.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/presentation/screens/auth_screen.dart';
import 'package:histouric_web/presentation/views/login_view.dart';

import 'config/navigation/router.dart';
import 'config/theme/app_theme.dart';

void main() {
  FluroRouterWrapper.configureRoutes();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      //obliga a que se seleccione alguno de los botones, ya no se puede cerrar el diálogo oprimiendo algo afuera
      builder: (context) => AlertDialog(
        title: const Text('¿Estas seguro?'),
        content: const Text(
            'Amet eu amet laborum occaecat deserunt. Sunt eiusmod exercitation in cillum id quis qui consequat fugiat esse culpa. Consectetur amet proident sint ad consequat id.'),
        actions: [
          TextButton(
            onPressed: () => NavigationService.pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => NavigationService.pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

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
      home: const AuthScreen(
        child: LoginView(),
      ),
    );
  }
}

// home: AuthScreen(
//   child: Text(''),
// ),
