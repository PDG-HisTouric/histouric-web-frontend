import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.watch<ProfileBloc>();
    final Set<String> _selectedRoles = profileBloc.state.selectedRoles;

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
              ),
            ),
            const SizedBox(height: 16.0),
            _buildRolesSection(context),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0266C8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 4.0,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Text(
                  'Guardar cambios',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
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

  final bool isSelected = selectedRoles.contains(role);
  final Color cardColor = isSelected ? const Color(0xff0266C8) : Colors.white;
  final Color iconColor = isSelected ? Colors.white : const Color(0xff0266C8);
  final IconData iconData = _roleIcons[role] ?? Icons.person;

  return GestureDetector(
    onTap: () {
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
