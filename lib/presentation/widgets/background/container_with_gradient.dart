import 'package:flutter/material.dart';

class ContainerWithGradient extends StatelessWidget {
  final Color? initialColor;
  final Color? finalColor;
  final Alignment? begin;
  final Alignment? end;

  const ContainerWithGradient({
    super.key,
    this.initialColor,
    this.finalColor,
    this.begin,
    this.end,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            initialColor ?? colorScheme.primary,
            finalColor ?? colorScheme.primary.withOpacity(0.1),
          ],
          begin: begin ?? Alignment.topCenter,
          end: end ?? Alignment.bottomCenter,
        ),
      ),
    );
  }
}
