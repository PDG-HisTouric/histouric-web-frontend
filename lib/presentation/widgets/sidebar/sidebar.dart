import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../config/config.dart';
import '../../blocs/blocs.dart';
import 'menu_item.dart';
import 'sidemenu_title.dart';
import 'text_separator.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isAdmin =
        context.read<AuthBloc>().state.roles!.contains('ADMIN');
    final bool isResearcher =
        context.read<AuthBloc>().state.roles!.contains('RESEARCHER');

    return PointerInterceptor(
      child: Container(
        width: 220,
        height: double.infinity,
        decoration: buildBoxDecoration(context),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            const SidemenuTitle(),
            const TextSeparator(text: 'Usuario'),
            MenuItem(
              text: 'Perfil',
              icon: Icons.person_outline,
              onPressed: () {
                context.read<SidemenuBloc>().closeMenu();
                NavigationService.navigateTo(FluroRouterWrapper.dashboardRoute);
              },
            ),
            const SizedBox(height: 20),
            if (isAdmin) const _AdminOptions(),
            if (isResearcher) const SizedBox(height: 20),
            if (isResearcher) const _ResearcherOptions(),
            const SizedBox(height: 50),
            const TextSeparator(text: 'Salir'),
            MenuItem(
              text: 'Cerrar sesión',
              icon: Icons.exit_to_app_outlined,
              onPressed: () {
                context.read<SidemenuBloc>().closeMenu();
                context.read<AuthBloc>().logout();
                context.read<SidemenuBloc>().disposeMenuController();
                NavigationService.replaceTo(FluroRouterWrapper.loginRoute);
              },
            ),
            const SizedBox(height: 50),
            const TextSeparator(text: 'Prueba'),
            MenuItem(
              text: 'Prueba',
              icon: Icons.lightbulb_circle,
              onPressed: () {
                context.read<SidemenuBloc>().closeMenu();
                NavigationService.navigateTo(FluroRouterWrapper.prueba);
              },
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BoxDecoration(
      gradient: LinearGradient(
        colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      boxShadow: [BoxShadow(color: colorScheme.primary, blurRadius: 10)],
    );
  }
}

class _AdminOptions extends StatelessWidget {
  const _AdminOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextSeparator(text: 'Admin'),
        MenuItem(
          text: 'Usuarios',
          icon: Icons.supervised_user_circle_rounded,
          onPressed: () {
            context.read<SidemenuBloc>().closeMenu();
            NavigationService.navigateTo(FluroRouterWrapper.usersTable);
          },
        ),
      ],
    );
  }
}

class _ResearcherOptions extends StatelessWidget {
  const _ResearcherOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextSeparator(text: 'Researcher'),
        MenuItem(
          text: 'Mapa',
          icon: Icons.map_outlined,
          onPressed: () {
            context.read<SidemenuBloc>().closeMenu();
            NavigationService.navigateTo(FluroRouterWrapper.bicsScreen);
          },
        ),
      ],
    );
  }
}
