import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../blocs/blocs.dart';
import '../form/custom_elevated_button_squared.dart';
import 'card_for_edit_from_admin.dart';
import 'card_for_edit_or_create.dart';

import 'card_for_view.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  String _getLabelForMainButton(ProfilePurpose profilePurpose) {
    if (profilePurpose != ProfilePurpose.viewMyProfile) return 'Guardar';
    return 'Editar';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final profileBloc = context.watch<ProfileBloc>();
    final ProfilePurpose profilePurpose = profileBloc.state.profilePurpose;
    final alertBloc = context.watch<AlertBloc>();

    if (profileBloc.state.initializingControllers) {
      return const Center(child: CircularProgressIndicator());
    }

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
            if (profilePurpose == ProfilePurpose.editMyProfile ||
                profilePurpose == ProfilePurpose.createUserFromAdmin)
              CardForEditOrCreate(
                buildRoleSelection: _buildRolesSection,
                profileBloc: profileBloc,
              ),
            if (profilePurpose == ProfilePurpose.viewMyProfile)
              CardForView(
                buildRoleSelection: _buildRolesSection,
                profileBloc: profileBloc,
              ),
            if (profilePurpose == ProfilePurpose.editUserFromAdmin)
              CardForEditFromAdmin(
                buildRoleSelection: _buildRolesSection,
                profileBloc: profileBloc,
              ),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                CustomElevatedButtonSquared(
                  backgroundColor: colors.primary,
                  onPressed: () async {
                    if (profilePurpose == ProfilePurpose.viewMyProfile) {
                      context.read<ProfileBloc>().startEditing();
                      return;
                    }

                    if (profileBloc.state.selectedRoles.isEmpty) {
                      Dialogs.showErrorDialog(
                        context: context,
                        content: "Tienes que seleccionar al menos un rol",
                      );
                      return;
                    }

                    if (profilePurpose == ProfilePurpose.editMyProfile) {
                      context.read<ProfileBloc>().saveChanges();
                      return;
                    }

                    if (profilePurpose == ProfilePurpose.editUserFromAdmin) {
                      await context.read<ProfileBloc>().saveChanges();
                      while (profileBloc.state.isSaving) {
                        await Future.delayed(const Duration(milliseconds: 100));
                      }
                      NavigationService.pop();
                      return;
                    }
                    if (profilePurpose == ProfilePurpose.createUserFromAdmin) {
                      await context.read<ProfileBloc>().createUserFromAdmin();
                      while (profileBloc.state.isSaving) {
                        await Future.delayed(const Duration(milliseconds: 100));
                      }
                      NavigationService.pop();
                      return;
                    }
                  },
                  textColor: colors.onPrimary,
                  fontWeightBold: true,
                  label: _getLabelForMainButton(profilePurpose),
                ),
                if (profilePurpose != ProfilePurpose.viewMyProfile)
                  const SizedBox(width: 16.0),
                if (profilePurpose != ProfilePurpose.viewMyProfile)
                  CustomElevatedButtonSquared(
                    backgroundColor: colors.secondary,
                    onPressed: () {
                      if (profilePurpose == ProfilePurpose.editMyProfile) {
                        context.read<ProfileBloc>().cancelEditing();
                      } else {
                        NavigationService.pop();
                      }
                    },
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

Widget _buildRolesSection(BuildContext context) {
  final profileBloc = context.watch<ProfileBloc>();
  final profilePurpose = profileBloc.state.profilePurpose;
  final isAdminUser = context.watch<AuthBloc>().state.roles!.contains('ADMIN');

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Roles',
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 15.0),
      Wrap(
        spacing: 8.0,
        children: (isAdminUser ||
                profilePurpose == ProfilePurpose.editUserFromAdmin ||
                profilePurpose == ProfilePurpose.createUserFromAdmin)
            ? _roles.map((role) => _buildRoleCard(role, context)).toList()
            : profileBloc.state.selectedRoles
                .map((role) => _buildRoleCard(role, context))
                .toList(),
      ),
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
  final bool isSelected;
  final Set<String> selectedRoles;
  final colors = Theme.of(context).colorScheme;
  final profileBloc = context.watch<ProfileBloc>();
  final profilePurpose = profileBloc.state.profilePurpose;

  if (profilePurpose != ProfilePurpose.viewMyProfile) {
    selectedRoles = profileBloc.state.selectedRoles;
  } else {
    selectedRoles = context.watch<AuthBloc>().state.roles!.toSet();
  }

  if (profilePurpose != ProfilePurpose.viewMyProfile) {
    isSelected = selectedRoles.contains(role);
  } else {
    isSelected = selectedRoles.contains(mapRole(role));
  }

  final Color cardColor = isSelected ? colors.primary : colors.onPrimary;
  final Color iconColor = isSelected ? colors.onPrimary : colors.primary;
  final IconData iconData = _roleIcons[role] ?? Icons.person;

  return GestureDetector(
    onTap: () {
      if (profilePurpose == ProfilePurpose.viewMyProfile) return;
      if (isSelected) {
        profileBloc.removeRole(role); //TODO: USE CONTEXT.READ
      } else {
        profileBloc.addRole(role); //TODO: USE CONTEXT.READ
      }
    },
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(shape: BoxShape.circle, color: cardColor),
          child: Icon(iconData, size: 24.0, color: iconColor),
        ),
        Text(
          role,
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
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
