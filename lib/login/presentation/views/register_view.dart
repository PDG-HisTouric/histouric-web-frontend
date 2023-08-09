import 'package:flutter/material.dart';
import 'package:histouric_web/login/presentation/widgets/custom_elevated_button.dart';
import 'package:histouric_web/login/presentation/widgets/divider_with_message.dart';
import 'package:histouric_web/login/presentation/widgets/widgets.dart';

import '../../../config/navigation/navigation_service.dart';
import '../../../config/navigation/router.dart';
import '../widgets/bottom_message_with_button.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
        const CustomTextFormField(
          hint: "Email",
          label: "Email",
        ),
        const SizedBox(height: 20),
        const CustomTextFormField(
          hint: "Apodo",
          label: "Apodo",
        ),
        const SizedBox(height: 20),
        const CustomTextFormField(
          hint: "Contraseña",
          label: "Contraseña",
          obscureText: true,
        ),
        const SizedBox(height: 20),
        CustomElevatedButton(label: "Crear cuenta", onPressed: () {}),
        const SizedBox(height: 20),
        const DividerWithMessage(message: "o"),
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
