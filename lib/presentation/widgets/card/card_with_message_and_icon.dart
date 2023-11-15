import 'package:flutter/material.dart';

class CardWithMessageAndIcon extends StatelessWidget {
  final void Function() onPressed;
  final String message;
  final IconData icon;

  const CardWithMessageAndIcon(
      {super.key,
      required this.onPressed,
      required this.message,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 10),
            Text(message),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: onPressed,
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
