import 'package:flutter/material.dart';

class CardWithAcceptAndCancelButtons extends StatelessWidget {
  final void Function() onAcceptPressed;
  final void Function() onCancelPressed;
  final String title;
  final String subtitle;
  final IconData icon;
  static double maxWidth = 300;
  static double maxHeight = 200;

  const CardWithAcceptAndCancelButtons({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onAcceptPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 10),
              Wrap(
                children: [
                  FilledButton(
                    onPressed: onAcceptPressed,
                    child: const Text('Aceptar'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                      onPressed: onCancelPressed,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(colors.secondary),
                      ),
                      child: const Text('Cancelar')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
