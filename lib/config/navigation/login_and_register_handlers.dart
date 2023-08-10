import 'package:fluro/fluro.dart';
import 'package:histouric_web/presentation/presentations.dart';

import '../../presentation/views/login_view.dart';
import '../../presentation/views/register_view.dart';

class LoginAndRegisterHandlers {
  static Handler login = Handler(
    handlerFunc: (context, parameters) {
      //TODO: Check if the user is already logged in
      return const AuthScreen(child: LoginView());
    },
  );

  static Handler register = Handler(
    handlerFunc: (context, parameters) {
      //TODO: Check if the user is already logged in
      return const AuthScreen(child: RegisterView());
    },
  );
}
