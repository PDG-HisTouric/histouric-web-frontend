import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/config/navigation/router.dart';
import 'package:histouric_web/presentation/blocs/blocs.dart';

import '../../config/helpers/dialogs.dart';
import '../widgets/bottom_message_with_button.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/divider_with_message.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(context: context),
      child: _Login(),
    );
  }
}

class _Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final email = context.watch<LoginFormBloc>().state.email.value;
    final password = context.watch<LoginFormBloc>().state.password.value;

    return Column(
      children: [
        Text(
          "Iniciar Sesión",
          style: TextStyle(
            color: colors.onPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        CustomTextFormField(
          hint: "Correo Electrónico",
          label: "Correo Electrónico",
          onChanged: (value) {
            context.read<LoginFormBloc>().emailChanged(value);
          },
          errorMessage: context.watch<LoginFormBloc>().state.email.errorMessage,
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          onChanged: (value) {
            context.read<LoginFormBloc>().passwordChanged(value);
          },
          hint: "Contraseña",
          label: "Contraseña",
          obscureText: true,
          errorMessage:
              context.watch<LoginFormBloc>().state.password.errorMessage,
        ),
        const SizedBox(height: 20),
        CustomElevatedButton(
          label: "Iniciar Sesión",
          onPressed: () async {
            if (context.read<LoginFormBloc>().isStateValid()) {
              await context.read<AuthBloc>().login(email, password)
                  ? NavigationService.replaceTo(
                      FluroRouterWrapper.dashboardRoute,
                    )
                  : Dialogs.showErrorDialog(
                      context: context,
                      content: "Credenciales inválidas",
                    );
            }
          },
        ),
        const SizedBox(height: 20),
        const DividerWithMessage(message: "o"),
        const SizedBox(height: 20),
        BottomMessageWithButton(
          message: "¿No tienes una cuenta?",
          buttonText: "Regístrate",
          onPressed: () {
            NavigationService.navigateTo(FluroRouterWrapper.registerRoute);
          },
        ),
      ],
    );
  }
}
