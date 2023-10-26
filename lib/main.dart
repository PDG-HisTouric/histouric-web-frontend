import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';

import 'config/config.dart';
import 'firebase_options.dart';
import 'infrastructure/infrastructure.dart';
import 'presentation/blocs/blocs.dart';
import 'presentation/presentation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  FluroRouterWrapper.configureRoutes();
  runApp(const MainApp());
  GooglePicker.callGapiLoaded();
  GooglePicker.callGisLoaded(
    clientId: Environment.pickerApiClientId,
    scopes: Environment.pickerApiScopes,
  );
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
      // home: const AuthScreen(child: LoginView()),
      // home: const BicsView(), //TODO: QUITAR
      home: const Scaffold(
        body: BicsView(),
        // body: SearchAndSelectHistoriesView(),
      ),
    );
  }
}
