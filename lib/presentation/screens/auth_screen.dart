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
    return BlocProvider(
      create: (context) => AlertBloc(),
      child: _AuthScreen(child: child),
    );
  }
}

class _AuthScreen extends StatefulWidget {
  final Widget child;

  const _AuthScreen({required this.child});

  @override
  State<_AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<_AuthScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<AlertBloc>().updateAnimationController(
          AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colors = Theme.of(context).colorScheme;
    final authStatus = context.watch<AuthBloc>().state.authStatus;
    final alertBloc = context.watch<AlertBloc>();

    if (authStatus == AuthStatus.checking) {
      return const Center(child: CircularProgressIndicator());
    }

    if (authStatus == AuthStatus.authenticated) {
      return const DashboardScreen(child: ProfileView());
    }

    if (alertBloc.state.animationControllerInitiated == false) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          const ContainerWithGradient(),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  SizedBox(
                      height: (authStatus == AuthStatus.loggingIn)
                          ? size.height * 0.1 - 36
                          : size.height * 0.1),
                  if (authStatus == AuthStatus.loggingIn)
                    const CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: widget.child,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: alertBloc.state.animationController,
            builder: (context, _) => Stack(
              children: [
                if (alertBloc.state.isAlertOpen)
                  Opacity(
                    opacity: alertBloc.state.opacity().value,
                    child: GestureDetector(
                      onTap: () => context.read<AlertBloc>().closeAlert(),
                      child: Container(
                        width: size.width,
                        height: size.height,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                if (alertBloc.state.child != null)
                  Transform.translate(
                    offset: Offset(
                        size.width / 2 -
                            CardWithAcceptAndCancelButtons.maxWidth / 2,
                        alertBloc.state
                            .movement(
                                size.height, CardWithMessageAndIcon.maxWidth)
                            .value),
                    child: alertBloc.state.child!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
