import 'package:fluro/fluro.dart';

import '../../presentation/screens/dashboard_screen.dart';

class DashboardHandlers {
  static Handler dashboard = Handler(handlerFunc: (context, parameters) {
    return const DashboardScreen();
  });
}
