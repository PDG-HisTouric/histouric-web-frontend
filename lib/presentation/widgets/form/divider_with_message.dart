import 'package:flutter/material.dart';

class DividerWithMessage extends StatelessWidget {
  final String message;

  const DividerWithMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(color: colors.onPrimary, height: 36),
          ),
        ),
        Text(
          message,
          style: TextStyle(
            color: colors.onPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Divider(color: colors.onPrimary, height: 36),
          ),
        ),
      ],
    );
  }
}
