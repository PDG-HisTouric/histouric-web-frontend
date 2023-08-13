import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/infrastructure/datasource/datasources.dart';
import 'package:histouric_web/infrastructure/datasource/spring_boot_user_datasource.dart';
import 'package:histouric_web/infrastructure/repositories/repositories.dart';
import 'package:histouric_web/infrastructure/repositories/user_repository_impl.dart';
import 'package:histouric_web/infrastructure/services/services.dart';
import 'package:histouric_web/presentation/blocs/auth_bloc/auth_bloc.dart';
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
    return BlocProvider(
      create: (context) => AuthBloc(
        userRepository: UserRepositoryImpl(
          userDatasource: SpringBootUserDatasource(),
        ),
        keyValueStorageService: KeyValueStorageServiceImpl(),
        authRepository: AuthRepositoryImpl(
          authDatasource: SpringBootLoginDatasource(),
        ),
        context: context,
      ),
      child: _MaterialAppWithFluro(),
    );
  }
}

class _MaterialAppWithFluro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = AppTheme(colorScheme: const Color(0xff0266C8));

    BlocProvider.of<AuthBloc>(context, listen: false).checkToken();
    print("lo llamé desde el material app");

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
