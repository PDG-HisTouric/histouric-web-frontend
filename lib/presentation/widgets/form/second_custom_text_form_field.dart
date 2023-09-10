import 'package:flutter/material.dart';

class SecondCustomTextFormField extends StatelessWidget {
  final String labelText;
  final Color primaryColor;
  final String? hintText;
  final Color hintColor;
  final Icon? prefixIcon;
  final int? maxLines;
  final int? minLines;

  const SecondCustomTextFormField({
    super.key,
    required this.labelText,
    this.primaryColor = Colors.black,
    this.hintText,
    this.hintColor = Colors.grey,
    this.prefixIcon,
    this.maxLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText, // Etiqueta que se muestra arriba del campo
          labelStyle: TextStyle(
            color: primaryColor, // Color del texto de la etiqueta
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              // Color del borde cuando el campo no está enfocado
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
              // Color del borde cuando el campo está enfocado
            ),
          ),
          hintText: hintText, // Texto de sugerencia dentro del campo
          hintStyle: TextStyle(
            color: hintColor, // Color del texto de sugerencia
          ),
          // Icono opcional a la izquierda del campo
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
