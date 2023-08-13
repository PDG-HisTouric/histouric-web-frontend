import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

import '../../infrastructure/inputs/inputs.dart';
import 'custom_elevated_button_squared.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.watch<ProfileBloc>();
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (profileBloc.state.isEditing)
              CardForEdit(
                profileBloc: profileBloc,
              )
            else
              CardForView(
                profileBloc: profileBloc,
              ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                CustomElevatedButtonSquared(
                  backgroundColor: colors.primary,
                  onPressed: () {
                    context.read<ProfileBloc>().state.isEditing
                        ? context.read<ProfileBloc>().saveChanges()
                        : context.read<ProfileBloc>().startEditing();
                  },
                  label: profileBloc.state.isEditing ? 'Guardar' : 'Editar',
                  textColor: colors.onPrimary,
                  fontWeightBold: true,
                ),
                if (profileBloc.state.isEditing) const SizedBox(width: 16.0),
                if (profileBloc.state.isEditing)
                  CustomElevatedButtonSquared(
                    backgroundColor: colors.secondary,
                    onPressed: context.read<ProfileBloc>().cancelEditing,
                    label: 'Cancelar',
                    textColor: colors.onSecondary,
                    fontWeightBold: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardForEdit extends StatelessWidget {
  final ProfileBloc profileBloc;

  const CardForEdit({super.key, required this.profileBloc});

  @override
  Widget build(BuildContext context) {
    final isAdminUser =
        context.watch<AuthBloc>().state.roles!.contains('ADMIN');

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Los campos que deje en blanco no serán actualizados",
            textAlign: TextAlign.center),
        const SizedBox(height: 16.0),
        TextField(
          controller: profileBloc.state.emailController,
          decoration: InputDecoration(
            errorText: profileBloc.state.email.displayError == EmailError.empty
                ? null
                : profileBloc.state.email.errorMessage,
            labelText: 'Correo electrónico',
          ),
          onChanged: context.read<ProfileBloc>().changeEmail,
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: profileBloc.state.passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            errorText:
                profileBloc.state.password.displayError == PasswordError.empty
                    ? null
                    : profileBloc.state.password.errorMessage,
          ),
          onChanged: context.read<ProfileBloc>().changePassword,
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: profileBloc.state.usernameController,
          decoration: InputDecoration(
            labelText: 'Nombre de usuario',
            errorText:
                profileBloc.state.nickname.displayError == NicknameError.empty
                    ? null
                    : profileBloc.state.nickname.errorMessage,
          ),
          onChanged: context.read<ProfileBloc>().changeNickname,
        ),
        const SizedBox(height: 16.0),
        if (isAdminUser) _buildRolesSection(context),
        if (isAdminUser) const SizedBox(height: 16.0),
      ],
    );
  }
}

class CardForView extends StatelessWidget {
  final ProfileBloc profileBloc;

  const CardForView({super.key, required this.profileBloc});

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProfileBloc>().state.isSaving;

    if (isSaving) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
        _buildRolesSection(context),
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
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

Widget _buildRolesSection(BuildContext context) {
  final profileBloc = context.watch<ProfileBloc>();
  final isAdminUser = context.watch<AuthBloc>().state.roles!.contains('ADMIN');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Roles',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 15.0),
      Wrap(
          spacing: 8.0,
          children: (isAdminUser)
              ? _roles.map((role) => _buildRoleCard(role, context)).toList()
              : profileBloc.state.selectedRoles
                  .map((role) => _buildRoleCard(role, context))
                  .toList()),
    ],
  );
}

final List<String> _roles = [
  'Administrador',
  'Investigador',
  'Gestor de Turismo',
];

String mapRole(String role) {
  switch (role) {
    case 'Administrador':
      return 'ADMIN';
    case 'Investigador':
      return 'RESEARCHER';
    case 'Gestor de Turismo':
      return 'TOURISM_MANAGER';
    default:
      return '';
  }
}

Widget _buildRoleCard(String role, BuildContext context) {
  final profileBloc = context.watch<ProfileBloc>();
  final Set<String> selectedRoles;
  if (profileBloc.state.isEditing) {
    selectedRoles = profileBloc.state.selectedRoles;
  } else {
    selectedRoles = context.watch<AuthBloc>().state.roles!.toSet();
  }
  final colors = Theme.of(context).colorScheme;

  final bool isSelected;
  if (profileBloc.state.isEditing) {
    isSelected = selectedRoles.contains(role);
  } else {
    isSelected = selectedRoles.contains(mapRole(role));
  }

  final Color cardColor = isSelected ? colors.primary : colors.onPrimary;
  final Color iconColor = isSelected ? colors.onPrimary : colors.primary;
  final IconData iconData = _roleIcons[role] ?? Icons.person;

  return GestureDetector(
    onTap: () {
      if (!profileBloc.state.isEditing) return;
      if (isSelected) {
        profileBloc.removeRole(role);
      } else {
        profileBloc.addRole(role);
      }
    },
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cardColor,
          ),
          child: Icon(
            iconData,
            size: 24.0,
            color: iconColor,
          ),
        ),
        Text(
          role,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

final Map<String, IconData> _roleIcons = {
  'Administrador': Icons.admin_panel_settings,
  'Investigador': Icons.history_edu,
  'Gestor de Turismo': Icons.tour,
};
