import 'package:flutter/material.dart';

class FirstCustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final bool obscureText;
  final double borderRadius;

  const FirstCustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.borderRadius = 40,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: colors.onPrimary),
      borderRadius: BorderRadius.circular(borderRadius),
    );

    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      style: TextStyle(fontSize: 16, color: colors.onPrimary),
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: colors.primary),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: colors.error),
        ),
        isDense: true,
        label: label != null
            ? Text(
                label!,
                style: TextStyle(fontSize: 16, color: colors.onPrimary),
              )
            : null,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 16, color: colors.onPrimaryContainer),
        errorText: errorMessage,
        errorMaxLines: 2,
        focusColor: colors.primary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }
}
