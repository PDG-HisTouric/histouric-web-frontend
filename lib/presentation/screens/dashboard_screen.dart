import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../views/views.dart';
import '../widgets/widgets.dart';
import 'auth_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Widget child;

  const DashboardScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthBloc>().state.authStatus;

    if (authStatus == AuthStatus.checking) {
      return const Center(child: CircularProgressIndicator());
    }

    if (authStatus == AuthStatus.notAuthenticated) {
      return const AuthScreen(child: LoginView());
    }

    return BlocProvider(
      create: (context) => SidemenuBloc(),
      child: _Dashboard(child: child),
    );
  }
}

class _Dashboard extends StatefulWidget {
  final Widget child;

  const _Dashboard({required this.child});

  @override
  State<_Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<_Dashboard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<SidemenuBloc>().updateMenuController(
          AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final sideMenuBloc = context.watch<SidemenuBloc>();

    if (sideMenuBloc.state.menuInitiated == false) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          const ContainerWithGradient(),
          const BackgroundFigures(),
          Column(
            children: [
              Expanded(
                child: Column(
                  children: [const Navbar(), Expanded(child: widget.child)],
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: sideMenuBloc.state.menuController,
            builder: (context, _) => Stack(
              children: [
                if (sideMenuBloc.state.isMenuOpen)
                  Opacity(
                    opacity: sideMenuBloc.state.opacity().value,
                    child: GestureDetector(
                      onTap: () => sideMenuBloc.closeMenu(),
                      child: Container(
                        width: size.width,
                        height: size.height,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                Transform.translate(
                  offset: Offset(sideMenuBloc.state.movement().value, 0),
                  child: const Sidebar(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
