import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  final String loadingText;
  static double maxWidth = 300;
  static double maxHeight = 200;

  const LoadingCard({super.key, required this.loadingText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(loadingText),
            ],
          ),
        ),
      ),
    );
  }
}
