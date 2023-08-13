import 'package:flutter/material.dart';

class CustomElevatedButtonSquared extends StatelessWidget {
  final Color backgroundColor;
  final void Function()? onPressed;
  final String label;
  final Color textColor;
  final bool fontWeightBold;

  const CustomElevatedButtonSquared({
    super.key,
    required this.backgroundColor,
    this.onPressed,
    required this.label,
    required this.textColor,
    required this.fontWeightBold,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 4.0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.0,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: fontWeightBold ? FontWeight.bold : null,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
