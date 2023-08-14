import 'package:fluro/fluro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/domain/entities/entities.dart';
import 'package:histouric_web/presentation/views/profile_view_from_admin.dart';

import '../../presentation/blocs/blocs.dart';
import '../../presentation/screens/dashboard_screen.dart';
import '../../presentation/screens/screens.dart';
import '../../presentation/views/views.dart';

class DashboardHandlers {
  static Handler dashboard = Handler(handlerFunc: (context, parameters) {
    return const DashboardScreen(
      child: ProfileView(),
    );
  });

  static Handler usersTable = Handler(handlerFunc: (context, parameters) {
    return const DashboardScreen(
      child: UsersTable(),
    );
  });

  static Handler editUserFromTable =
      Handler(handlerFunc: (context, parameters) {
    final nickname = parameters['nickname']?.first;
    final String token =
        BlocProvider.of<AuthBloc>(context!, listen: false).state.token!;

    // final usersTableBloc =
    //     BlocProvider.of<UsersTableBloc>(context, listen: false);

    return DashboardScreen(
      child: ProfileViewFromAdmin(
        token: token,
        profilePurpose: ProfilePurpose.editUserFromAdmin,
        nickname: nickname!,
      ),
    );
  });
}
