import 'package:flutter/material.dart';

import 'sidemenu_title.dart';
import 'menu_item.dart';
import 'text_separator.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  // void navigateTo(String routeName) {
  //   NavigationService.navigateTo(routeName);
  //   SideMenuProvider.closeMenu();
  // }

  @override
  Widget build(BuildContext context) {
    // final sideMenuProvider = Provider.of<SideMenuProvider>(context);

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
            onPressed: () {},
          ),
          const SizedBox(height: 50),
          const TextSeparator(text: 'Salir'),
          MenuItem(
              text: 'Cerrar sesión',
              icon: Icons.exit_to_app_outlined,
              onPressed: () {}),
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
        boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 10)]);
  }
}
