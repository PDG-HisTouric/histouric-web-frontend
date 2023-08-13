import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/config/navigation/router.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

import 'sidemenu_title.dart';
import 'menu_item.dart';
import 'text_separator.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isAdmin =
        context.read<AuthBloc>().state.roles!.contains('ADMIN');

    return Container(
      width: 220,
      height: double.infinity,
      decoration: buildBoxDecoration(context),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          SidemenuTitle(),
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
          if (isAdmin) const AdminOptions(),
          const SizedBox(height: 50),
          const TextSeparator(text: 'Salir'),
          MenuItem(
              text: 'Cerrar sesión',
              icon: Icons.exit_to_app_outlined,
              onPressed: () {
                context.read<SidemenuBloc>().closeMenu();
                context.read<AuthBloc>().logout();
                NavigationService.replaceTo(FluroRouterWrapper.loginRoute);
              }),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [BoxShadow(color: colorScheme.primary, blurRadius: 10)]);
  }
}

class AdminOptions extends StatelessWidget {
  const AdminOptions({super.key});

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
