import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final sideMenuBloc = context.watch<SidemenuBloc>();
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: colors.background,
        boxShadow: [BoxShadow(color: colors.background, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () => sideMenuBloc.openMenu(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
