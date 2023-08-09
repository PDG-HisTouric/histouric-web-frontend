import 'package:flutter/material.dart';

class BottomMessageWithButton extends StatelessWidget {
  final String message;
  final String buttonText;
  final void Function()? onPressed;

  const BottomMessageWithButton({
    super.key,
    required this.message,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.contain,
          child: Text(
            message,
            style: TextStyle(
              color: colors.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.contain,
          child: TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (states) => Colors.transparent,
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: colors.onBackground,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
