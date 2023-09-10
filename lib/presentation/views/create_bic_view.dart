import 'package:flutter/material.dart';

class CreateBICView extends StatelessWidget {
  const CreateBICView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear BIC"),
      ),
      body: const Center(
        child: Text("Crear BIC"),
      ),
    );
  }
}
