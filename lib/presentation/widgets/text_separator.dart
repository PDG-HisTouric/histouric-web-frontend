import 'package:flutter/material.dart';

class TextSeparator extends StatelessWidget {
  final String text;

  const TextSeparator({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
