import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/config.dart';
import '../../infrastructure/infrastructure.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(
        context: context,
        authRepository: AuthRepositoryImpl(
          authDatasource: AuthDatasourceImpl(),
        ),
      ),
      child: _Register(),
    );
  }
}

class _Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.25;
    final emailErrorMessage =
        context.watch<SignUpBloc>().state.email.errorMessage;
    final passwordErrorMessage =
        context.watch<SignUpBloc>().state.password.errorMessage;
    final nicknameErrorMessage =
        context.watch<SignUpBloc>().state.nickname.errorMessage;

    return Column(
      children: [
        Text(
          "Crear cuenta",
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
            onChanged: context.read<SignUpBloc>().changeEmail,
            errorMessage: emailErrorMessage,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: FirstCustomTextFormField(
            hint: "Contraseña",
            label: "Contraseña",
            obscureText: true,
            onChanged: context.read<SignUpBloc>().changePassword,
            errorMessage: passwordErrorMessage,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: FirstCustomTextFormField(
            hint: "Confirmar contraseña",
            label: "Confirmar contraseña",
            obscureText: true,
            onChanged: context.read<SignUpBloc>().changeConfirmPassword,
            errorMessage: passwordErrorMessage,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: FirstCustomTextFormField(
            hint: "Nombre de usuario",
            label: "Nombre de usuario",
            onChanged: context.read<SignUpBloc>().changeNickname,
            errorMessage: nicknameErrorMessage,
          ),
        ),
        const SizedBox(height: 20),
        CustomElevatedButtonRounded(
          label: "Crear cuenta",
          onPressed: () async {
            if (context.read<SignUpBloc>().isSignUpFormStateValid()) {
              context.read<SignUpBloc>().signUp()
                  ? NavigationService.navigateTo(
                      FluroRouterWrapper.loginRoute,
                    )
                  : Dialogs.showErrorDialog(
                      context: context,
                      content: "No se pudo crear la cuenta",
                    );
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
          message: "¿Ya tienes una cuenta?",
          buttonText: "Inicia sesión",
          onPressed: () {
            NavigationService.navigateTo(FluroRouterWrapper.loginRoute);
          },
        ),
      ],
    );
  }
}
