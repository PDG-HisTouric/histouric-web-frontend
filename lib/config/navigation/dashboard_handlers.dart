import 'package:fluro/fluro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/blocs.dart';
import '../../presentation/screens/dashboard_screen.dart';
import '../../presentation/screens/screens.dart';
import '../../presentation/views/views.dart';

class DashboardHandlers {
  static Handler dashboard = Handler(handlerFunc: (context, parameters) {
    return const DashboardScreen(
      child: ProfileView(
        forEditing: true,
      ),
    );
  });

  static Handler usersTable = Handler(handlerFunc: (context, parameters) {
    return const DashboardScreen(
      child: UsersTable(),
    );
  });
}
