import 'package:flutter/material.dart';
import 'package:histouric_web/login/presentation/widgets/custom_elevated_button.dart';
import 'package:histouric_web/login/presentation/widgets/divider_with_message.dart';
import 'package:histouric_web/login/presentation/widgets/widgets.dart';

import '../widgets/bottom_message_with_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colors.primary, colors.primary.withOpacity(0.1)],
              ),
            ),
            width: constraints.maxWidth,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          "Histouric",
                          style: TextStyle(
                            color: colors.onPrimary,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const CustomTextFormField(
                        hint: "Email",
                      ),
                      const SizedBox(height: 20),
                      const CustomTextFormField(
                        hint: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton(label: "Login", onPressed: () {}),
                      const SizedBox(height: 20),
                      const DividerWithMessage(message: "or"),
                      const SizedBox(height: 20),
                      BottomMessageWithButton(
                        message: "Don't have an account?",
                        buttonText: "Sign Up",
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
