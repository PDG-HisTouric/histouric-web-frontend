import 'package:fluro/fluro.dart';
import 'package:histouric_web/config/navigation/dashboard_handlers.dart';

import 'login_and_register_handlers.dart';

class FluroRouterWrapper {
  static final FluroRouter router = FluroRouter();

  static String rootRoute = '/';

  //Auth Routes
  static String loginRoute = '/login';
  static String registerRoute = '/register';

  //Dashboard Routes
  static String dashboardRoute = '/dashboard';
  static String usersTable = "/dashboard/users";

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
      transitionType: TransitionType.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
    router.define(
      registerRoute,
      handler: LoginAndRegisterHandlers.register,
      transitionType: TransitionType.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );

    //Dashboard routes
    router.define(
      dashboardRoute,
      handler: DashboardHandlers.dashboard,
      transitionType: TransitionType.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );

    router.define(
      usersTable,
      handler: DashboardHandlers.usersTable,
      transitionType: TransitionType.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
