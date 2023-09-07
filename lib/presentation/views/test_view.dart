import 'package:flutter/material.dart';

import '../../config/constants/constants.dart';
import '../js_bridge/js_bridge.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Text('Test View'),
        const SizedBox(height: 20),
        const Text('This view is only for testing purposes'),
        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text(
            "File picker",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            JSHelper.callFilePicker(
              apiKey: Environment.pickerApiKey,
              appId: Environment.pickerApiAppId,
            );
          },
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: Image.network(
            'https://drive.google.com/uc?export=view&id=1Uj27zjdTO3nfejVPV9GLBP_eAfBBJEM6',
          ),
        ),
      ],
    ));
  }
}
