import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  final String loadingText;
  const LoadingCard({super.key, required this.loadingText});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(loadingText),
          ],
        ),
      ),
    );
  }
}
