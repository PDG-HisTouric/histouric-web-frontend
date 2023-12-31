import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/config.dart';
import '../../blocs/blocs.dart';
import '../../widgets/widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(
        alertBloc: context.read<AlertBloc>(),
        authBloc: context.read<AuthBloc>(),
        context: context,
      ),
      child: _Login(),
    );
  }
}

class _Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.25;
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
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: FirstCustomTextFormField(
            hint: "Correo Electrónico",
            label: "Correo Electrónico",
            onChanged: context.read<LoginFormBloc>().emailChanged,
            errorMessage:
                context.watch<LoginFormBloc>().state.email.errorMessage,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: FirstCustomTextFormField(
            onChanged: context.read<LoginFormBloc>().passwordChanged,
            hint: "Contraseña",
            label: "Contraseña",
            obscureText: true,
            errorMessage:
                context.watch<LoginFormBloc>().state.password.errorMessage,
          ),
        ),
        const SizedBox(height: 20),
        CustomElevatedButtonRounded(
          label: "Iniciar Sesión",
          onPressed: () {
            if (context.read<LoginFormBloc>().isLoginStateValid()) {
              context
                  .read<LoginFormBloc>()
                  .signIn(email, password)
                  .then((isTheUserLoggedIn) {
                if (isTheUserLoggedIn) {
                  NavigationService.replaceTo(
                      FluroRouterWrapper.dashboardRoute);
                }
              });
            }
          },
        ),
        const SizedBox(height: 20),
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: const DividerWithMessage(message: "o"),
        ),
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
