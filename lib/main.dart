import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/infrastructure/datasource/datasources.dart';

import 'package:histouric_web/infrastructure/repositories/repositories.dart';
import 'package:histouric_web/infrastructure/services/services.dart';
import 'package:histouric_web/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
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
