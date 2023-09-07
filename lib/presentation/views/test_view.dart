import 'package:flutter/material.dart';

import '../../config/constants/constants.dart';
import '../js_bridge/js_bridge.dart';

class TestView extends StatelessWidget {
  TestView({super.key});

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
            "Click to Check Platform",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            print(
              "Probando... ${const String.fromEnvironment("PRUEBA", defaultValue: "no funcionó")}",
            );
            print(
              "Probando... ${const String.fromEnvironment("PRUEBA1", defaultValue: "no funcionó")}",
            );
            getPlatform();
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          child: const Text(
            "OpenTab",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            // Loader
            String dataFromJS = await JSHelper.callOpenTab();
            print("dataFromJS ----------- $dataFromJS");
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          child: const Text(
            "Call JS Promise Function",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () async {
            // Loader
            String dataFromJS = await JSHelper.callJSPromise();

            print("dataFromJS test ----------- $dataFromJS");
          },
        ),
        const SizedBox(height: 16),
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
      ],
    ));
  }

  void getPlatform() {
    String platForm = JSHelper.getPlatformFromJS();
    print(platForm);
  }
}
