import 'package:flutter/material.dart';

import '../navigation/navigation.dart';

class Dialogs {
  static void showErrorDialog({
    required BuildContext context,
    String title = "Error",
    String content = "Algo salió mal...",
    String buttonText = "Aceptar",
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          FilledButton(
            onPressed: () => NavigationService.pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
