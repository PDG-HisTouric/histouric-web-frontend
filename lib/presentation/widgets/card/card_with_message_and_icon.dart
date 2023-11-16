import 'package:flutter/material.dart';

class CardWithMessageAndIcon extends StatelessWidget {
  final void Function() onPressed;
  final String message;
  final IconData icon;
  static double maxWidth = 300;
  static double maxHeight = 200;

  const CardWithMessageAndIcon(
      {super.key,
      required this.onPressed,
      required this.message,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: onPressed,
                child: const Text('Aceptar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
