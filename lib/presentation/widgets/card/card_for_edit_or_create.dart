import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../infrastructure/infrastructure.dart';
import '../../blocs/blocs.dart';

typedef BuildRoleSelection = Widget Function(BuildContext context);

class CardForEditOrCreate extends StatelessWidget {
  final ProfileBloc profileBloc;

  final BuildRoleSelection buildRoleSelection;

  const CardForEditOrCreate({
    super.key,
    required this.profileBloc,
    required this.buildRoleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final isAdminUser =
        context.watch<AuthBloc>().state.roles!.contains('ADMIN');

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (profileBloc.state.profilePurpose == ProfilePurpose.editMyProfile)
          const Text(
            "Los campos que deje en blanco no serán actualizados",
            textAlign: TextAlign.center,
          ),
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
        if (isAdminUser ||
            profileBloc.state.profilePurpose ==
                ProfilePurpose.createUserFromAdmin)
          buildRoleSelection(context),
        if (isAdminUser ||
            profileBloc.state.profilePurpose ==
                ProfilePurpose.createUserFromAdmin)
          const SizedBox(height: 16.0),
      ],
    );
  }
}
