import 'package:dio/dio.dart';
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
        const SizedBox(height: 20),
        ElevatedButton(
          child: const Text(
            "Hacer petición",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            final dio = Dio(BaseOptions(
              baseUrl:
                  'https://drive.google.com/uc?id=1Uj27zjdTO3nfejVPV9GLBP_eAfBBJEM6',
            ));
            final response = await dio.get('');
            print(response);
          },
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: Image.network(
            'https://lh3.googleusercontent.com/d/1Uj27zjdTO3nfejVPV9GLBP_eAfBBJEM6',
          ),
        ),
      ],
    ));
  }
}
