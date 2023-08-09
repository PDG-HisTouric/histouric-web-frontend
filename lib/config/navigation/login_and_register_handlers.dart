import 'package:fluro/fluro.dart';
import 'package:histouric_web/login/presentation/views/register_view.dart';

import '../../login/presentation/views/views.dart';

class LoginAndRegisterHandlers {
  static Handler login = Handler(
    handlerFunc: (context, parameters) {
      //TODO: Check if the user is already logged in
      return const LoginView();
    },
  );

  static Handler register = Handler(
    handlerFunc: (context, parameters) {
      //TODO: Check if the user is already logged in
      return const RegisterView();
    },
  );
}
