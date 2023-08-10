import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/config/navigation/router.dart';

import '../../infrastructure/datasource/spring_boot_login_datasource.dart';
import '../../infrastructure/repositories/auth_repository_impl.dart';
import '../../infrastructure/services/key_value_storage_service_impl.dart';
import '../blocs/login_bloc/login_bloc.dart';
import '../widgets/bottom_message_with_button.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/divider_with_message.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
          context: context,
          authRepository:
              AuthRepositoryImpl(authDatasource: SpringBootLoginDatasource()),
          keyValueStorageService: KeyValueStorageServiceImpl()),
      child: _Login(),
    );
  }
}

class _Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
            context.read<LoginBloc>().emailChanged(value);
          },
          errorMessage: context.watch<LoginBloc>().state.email.errorMessage,
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          onChanged: (value) {
            context.read<LoginBloc>().passwordChanged(value);
          },
          hint: "Contraseña",
          label: "Contraseña",
          obscureText: true,
          errorMessage: context.watch<LoginBloc>().state.password.errorMessage,
        ),
        const SizedBox(height: 20),
        CustomElevatedButton(
          label: "Iniciar Sesión",
          onPressed: () {
            context.read<LoginBloc>().submitLogin();
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
