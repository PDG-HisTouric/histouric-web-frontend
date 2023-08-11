import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';
import 'package:histouric_web/presentation/presentations.dart';

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
          children: [
            TextField(
              controller: profileBloc.state.emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
              enabled: profileBloc.state.isEditing,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: profileBloc.state.passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
              enabled: profileBloc.state.isEditing,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: profileBloc.state.usernameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
              ),
              enabled: profileBloc.state.isEditing,
            ),
            const SizedBox(height: 16.0),
            _buildRolesSection(context),
            const SizedBox(height: 24.0),
            Wrap(
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
                SizedBox(width: 16.0),
                CustomElevatedButtonSquared(
                  backgroundColor: colors.error,
                  onPressed: () {},
                  label: 'Eliminar',
                  textColor: colors.onError,
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

Widget _buildRolesSection(BuildContext context) {
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
        children: _roles.map((role) => _buildRoleCard(role, context)).toList(),
      ),
    ],
  );
}

final List<String> _roles = [
  'Administrador',
  'Investigador',
  'Gestor de Turismo',
];

Widget _buildRoleCard(String role, BuildContext context) {
  final profileBloc = context.watch<ProfileBloc>();
  final Set<String> selectedRoles = profileBloc.state.selectedRoles;
  final colors = Theme.of(context).colorScheme;

  final bool isSelected = selectedRoles.contains(role);
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
