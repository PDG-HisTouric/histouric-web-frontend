import 'package:flutter/material.dart';
import 'package:histouric_web/login/presentation/widgets/custom_elevated_button.dart';
import 'package:histouric_web/login/presentation/widgets/divider_with_message.dart';
import 'package:histouric_web/login/presentation/widgets/widgets.dart';

import '../widgets/bottom_message_with_button.dart';

class AuthScreen extends StatelessWidget {
  final Widget child;

  const AuthScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colors.primary, colors.primary.withOpacity(0.1)],
              ),
            ),
            width: MediaQuery.sizeOf(context).width,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width,
                      height: size.height * 0.2,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "HisTouric",
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      width: size.width,
                      height: size.height * 0.6,
                      alignment: Alignment.center,
                      child: child,
                    )
                    // child,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
