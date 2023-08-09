import 'package:fluro/fluro.dart';

import 'login_and_register_handlers.dart';

class FluroRouterWrapper {
  static final FluroRouter router = FluroRouter();

  static String rootRoute = '/';

  //Auth Router
  static String loginRoute = '/login';
  static String registerRoute = '/register';

  static void configureRoutes() {
    //Auth routes
    router.define(
      rootRoute,
      handler: LoginAndRegisterHandlers.login,
      transitionType: TransitionType.fadeIn,
    );
    router.define(
      loginRoute,
      handler: LoginAndRegisterHandlers.login,
      transitionType: TransitionType.inFromLeft,
    );
    router.define(
      registerRoute,
      handler: LoginAndRegisterHandlers.register,
      transitionType: TransitionType.inFromRight,
    );
  }
}
