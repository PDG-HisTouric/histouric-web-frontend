import 'package:flutter/material.dart';

import '../js/js_helper.dart';

class TestView extends StatelessWidget {
  TestView({super.key});
  final JSHelper _jsHelper = JSHelper();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Text('Test View'),
        const SizedBox(height: 20),
        const Text('This view is only for testing purposes'),
        ElevatedButton(
          child: const Text(
            "Click to Check Platform",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
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
            String dataFromJS = await _jsHelper.callOpenTab();
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
            String dataFromJS = await _jsHelper.callJSPromise();

            print("dataFromJS test ----------- $dataFromJS");
          },
        ),
      ],
    ));
  }

  void getPlatform() {
    String platForm = _jsHelper.getPlatformFromJS();
    print(platForm);
  }
}
