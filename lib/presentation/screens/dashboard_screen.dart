import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/config/navigation/router.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
import 'package:histouric_web/presentation/presentations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedUserBloc = context.watch<AuthBloc>();

    if (loggedUserBloc.state.authStatus == AuthStatus.checking) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (loggedUserBloc.state.authStatus == AuthStatus.notAuthenticated) {
      return const AuthScreen(child: LoginView());
    }

    return Scaffold(
      body: Center(
        child: Text("Dashboard"),
      ),
    );
  }
}
