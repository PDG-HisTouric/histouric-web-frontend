import 'package:fluro/fluro.dart';

import '../../presentation/presentation.dart';

class LoginAndRegisterHandlers {
  static Handler login = Handler(
    handlerFunc: (context, parameters) {
      return const AuthScreen(child: LoginView());
    },
  );

  static Handler register = Handler(
    handlerFunc: (context, parameters) {
      return const AuthScreen(child: RegisterView());
    },
  );

  static Handler temp = Handler(
    handlerFunc: (context, parameters) {
      return const CreateBICView();
    },
  );
}
