import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

typedef BuildRoleSelection = Widget Function(BuildContext context);

class CardForEditFromAdmin extends StatelessWidget {
  final ProfileBloc profileBloc;
  final BuildRoleSelection buildRoleSelection;

  const CardForEditFromAdmin({
    super.key,
    required this.profileBloc,
    required this.buildRoleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProfileBloc>().state.isSaving;

    if (isSaving) return const Center(child: CircularProgressIndicator());

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _SubtitleAndText(
          subtitle: 'Correo electrónico',
          text: profileBloc.state.email.value,
        ),
        const SizedBox(height: 16.0),
        _SubtitleAndText(
          subtitle: 'Nombre de usuario',
          text: profileBloc.state.nickname.value,
        ),
        const SizedBox(height: 16.0),
        buildRoleSelection(context),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class _SubtitleAndText extends StatelessWidget {
  const _SubtitleAndText({
    required this.subtitle,
    required this.text,
  });

  final String subtitle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
