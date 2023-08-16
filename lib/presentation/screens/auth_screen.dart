import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../views/views.dart';
import '../widgets/widgets.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatelessWidget {
  final Widget child;

  const AuthScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colors = Theme.of(context).colorScheme;
    final authStatus = context.watch<AuthBloc>().state.authStatus;

    if (authStatus == AuthStatus.checking) {
      return const Center(child: CircularProgressIndicator());
    }

    if (authStatus == AuthStatus.authenticated) {
      return const DashboardScreen(child: ProfileView());
    }

    return Scaffold(
      body: Stack(
        children: [
          const ContainerWithGradient(),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.1),
                  Container(
                    width: size.width,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "HisTouric",
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
