import 'package:fluro/fluro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/presentations.dart';

import '../../presentation/blocs/blocs.dart';
import '../../presentation/views/login_view.dart';
import '../../presentation/views/register_view.dart';

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
}
