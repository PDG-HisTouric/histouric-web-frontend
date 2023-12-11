import 'package:flutter/material.dart';

class BottomMessageWithButton extends StatefulWidget {
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
  State<BottomMessageWithButton> createState() =>
      _BottomMessageWithButtonState();
}

class _BottomMessageWithButtonState extends State<BottomMessageWithButton> {
  bool isHovered = false;

  void setIsHovered(bool value) {
    setState(() {
      isHovered = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setIsHovered(true),
      onExit: (_) => setIsHovered(false),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Text(
              widget.message,
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
              onPressed: widget.onPressed,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => Colors.transparent,
                ),
              ),
              child: Text(
                widget.buttonText,
                style: TextStyle(
                  color: colors.onBackground,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  decoration: isHovered
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
