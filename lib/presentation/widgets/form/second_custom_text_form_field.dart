import 'package:flutter/material.dart';

class SecondCustomTextFormField extends StatelessWidget {
  final String labelText;
  final Color? primaryColor;
  final String? hintText;
  final Icon? prefixIcon;
  final int? maxLines;
  final int? minLines;
  final String? errorMessage;
  final void Function(String value)? onChanged;
  final TextEditingController? controller;
  final bool enabled;

  const SecondCustomTextFormField({
    super.key,
    required this.labelText,
    this.primaryColor,
    this.hintText,
    this.prefixIcon,
    this.maxLines,
    this.minLines,
    this.errorMessage,
    this.onChanged,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final InputBorder primaryBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: primaryColor ?? colors.primary,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        keyboardType: TextInputType.multiline,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          errorText: errorMessage,
          errorMaxLines: 2,
          labelText: labelText,
          labelStyle: TextStyle(
            color: primaryColor,
          ),
          errorBorder: primaryBorder.copyWith(
            borderSide: BorderSide(color: colors.error),
          ),
          focusedErrorBorder: primaryBorder.copyWith(
            borderSide: BorderSide(color: colors.error),
          ),
          enabledBorder: primaryBorder,
          focusedBorder: primaryBorder,
          hintText: hintText,
          prefixIcon: prefixIcon,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
