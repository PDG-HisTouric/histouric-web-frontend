import 'package:flutter/material.dart';

import 'logo.dart';
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
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(context),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Logo(),
          SizedBox(height: 50),
          TextSeparator(text: 'main'),
          MenuItem(
            text: 'Dashboard',
            icon: Icons.compass_calibration_outlined,
            onPressed: () {},
            // onPressed: () => navigateTo(Flurorouter.dashboardRoute),
            // isActive:
            //     sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
          ),
          MenuItem(
              text: 'Orders',
              icon: Icons.shopping_cart_outlined,
              onPressed: () {}),
          MenuItem(
              text: 'Analytic',
              icon: Icons.show_chart_outlined,
              onPressed: () {}),
          MenuItem(
              text: 'Categories',
              icon: Icons.layers_outlined,
              onPressed: () {}),
          MenuItem(
              text: 'Products',
              icon: Icons.dashboard_outlined,
              onPressed: () {}),
          MenuItem(
              text: 'Discount',
              icon: Icons.attach_money_outlined,
              onPressed: () {}),
          MenuItem(
              text: 'Customers',
              icon: Icons.people_alt_outlined,
              onPressed: () {}),
          SizedBox(height: 30),
          TextSeparator(text: 'UI Elements'),
          MenuItem(
            text: 'Icons',
            icon: Icons.list_alt_outlined,
            onPressed: () {},
            // onPressed: () => navigateTo(Flurorouter.iconsRoute),
            // isActive: sideMenuProvider.currentPage == Flurorouter.iconsRoute,
          ),
          MenuItem(
              text: 'Marketing',
              icon: Icons.mark_email_read_outlined,
              onPressed: () {}),
          MenuItem(
              text: 'Campaign',
              icon: Icons.note_add_outlined,
              onPressed: () {}),
          MenuItem(
            text: 'Black',
            icon: Icons.post_add_outlined,
            onPressed: () {},
            // onPressed: () => navigateTo(Flurorouter.blankRoute),
            // isActive: sideMenuProvider.currentPage == Flurorouter.blankRoute,
          ),
          SizedBox(height: 50),
          TextSeparator(text: 'Exit'),
          MenuItem(
              text: 'Logout',
              icon: Icons.exit_to_app_outlined,
              onPressed: () {}),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BoxDecoration(
        gradient: LinearGradient(colors: [
          colorScheme.primary,
          colorScheme.primary.withOpacity(0.8),
        ]),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]);
  }
}
