import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

class SidemenuTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sideMenuBloc = context.watch<SidemenuBloc>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.bubble_chart_outlined, color: colorScheme.onPrimary),
          const SizedBox(width: 10),
          Text(
            'HisTouric',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () => context.read<SidemenuBloc>().closeMenu(),
            icon: Icon(Icons.close, color: colorScheme.onPrimary),
          )
        ],
      ),
    );
  }
}
