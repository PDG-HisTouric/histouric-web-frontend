import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:histouric_web/config/navigation/navigation_service.dart';
import 'package:histouric_web/config/navigation/router.dart';
import 'package:histouric_web/login/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:histouric_web/login/presentation/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    

    return BlocProvider(
      create: (context) => LoginBloc(),
      child: _Login(),);
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
          hint: "Email",
          label: "Email",
          onChanged: (value) {
            context.read<LoginBloc>().emailChanged(value);
          },
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          onChanged: (value) {
            context.read<LoginBloc>().passwordChanged(value);
          },
          hint: "Contraseña",
          label: "Contraseña",
          obscureText: true,
        ),
        const SizedBox(height: 20),
        CustomElevatedButton(label: "Iniciar Sesión", onPressed: () {
          context.read<LoginBloc>().submitLogin();
        },),
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
