import 'package:fluro/fluro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/blocs/blocs.dart';
import '../../presentation/presentation.dart';

class DashboardHandlers {
  static Handler dashboard = Handler(handlerFunc: (context, parameters) {
    return const DashboardScreen(child: ProfileView());
  });

  static Handler usersTable = Handler(handlerFunc: (context, parameters) {
    return const DashboardScreen(child: UsersTable());
  });

  static Handler editUserFromTable = Handler(handlerFunc: (
    context,
    parameters,
  ) {
    final nickname = parameters['nickname']?.first;

    final String token = BlocProvider.of<AuthBloc>(
      context!,
      listen: false,
    ).state.token!;

    return DashboardScreen(
      child: ProfileViewFromAdmin(
        token: token,
        profilePurpose: ProfilePurpose.editUserFromAdmin,
        nickname: nickname!,
      ),
    );
  });

  static Handler createUserFromTable = Handler(handlerFunc: (
    context,
    parameters,
  ) {
    final String token = BlocProvider.of<AuthBloc>(
      context!,
      listen: false,
    ).state.token!;

    return DashboardScreen(
      child: ProfileViewFromAdmin(
        token: token,
        profilePurpose: ProfilePurpose.createUserFromAdmin,
        nickname: '',
      ),
    );
  });

  static Handler prueba = Handler(handlerFunc: (context, parameters) {
    return DashboardScreen(child: TestView());
  });
}
