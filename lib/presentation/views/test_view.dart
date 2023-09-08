import 'package:universal_html/html.dart';

import 'package:flutter/material.dart';

import '../../config/constants/constants.dart';
import '../js_bridge/js_bridge.dart';

import 'dart:ui_web' as ui;

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
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: 400,
            height: 400,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(height: 853, width: 1280, child: HtmlImage()),
            ),
          ),
        ),
      ],
    ));
  }
}

class HtmlImage extends StatelessWidget {
  HtmlImage({super.key}) {
    ui.platformViewRegistry.registerViewFactory('image', (int viewId) {
      var image = ImageElement(
        src: 'https://drive.google.com/uc?id=1Uj27zjdTO3nfejVPV9GLBP_eAfBBJEM6',
      );
      image.style.height = '100%';
      image.style.width = '100%';
      return image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(viewType: 'image');
  }
}
