import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

  final void Function()? onPressed;
  final String label;


  const CustomElevatedButton({super.key, this.onPressed, required this.label,});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              shape:
                  MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              // backgroundColor:
              //     MaterialStateProperty.all<Color>(Colors.white),
              padding:
                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}