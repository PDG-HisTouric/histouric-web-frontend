import 'package:googleapis/chat/v1.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:universal_html/html.dart';

import 'package:flutter/material.dart';

import '../../config/constants/constants.dart';
import '../js_bridge/js_bridge.dart';

import 'dart:ui_web' as ui;

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  _waitUntilThePickerIsOpen() async {
    while (
        !JSHelper.callGetIsThereAnError() && !JSHelper.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  _waitUntilThePickerIsClosed() async {
    while (JSHelper.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  List<String> filesIds = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
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
              onPressed: () async {
                JSHelper.callFilePicker(
                  apiKey: Environment.pickerApiKey,
                  appId: Environment.pickerApiAppId,
                );
                await _waitUntilThePickerIsOpen();
                await _waitUntilThePickerIsClosed();
                if (!JSHelper.callGetIsThereAnError()) {
                  setState(() {
                    filesIds = [
                      ...filesIds,
                      ...JSHelper.callGetSelectedFilesIds()
                    ];
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            if (filesIds.isEmpty)
              const Text(
                'No files selected',
                style: TextStyle(color: Colors.red),
              ),
            if (filesIds.isNotEmpty) ...[
              const Text('Selected files:'),
              const SizedBox(height: 20),
            ],
            if (filesIds.isNotEmpty)
              Wrap(
                children: filesIds
                    .map(
                      (id) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 400,
                          height: 400,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              height: 853,
                              width: 1280,
                              child: HtmlImage(imageId: id),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class HtmlImage extends StatelessWidget {
  final String imageId;
  HtmlImage({super.key, required this.imageId}) {
    ui.platformViewRegistry.registerViewFactory('image-$imageId', (int viewId) {
      var image = ImageElement(
        src: 'https://drive.google.com/uc?id=$imageId',
      );
      image.style.height = '100%';
      image.style.width = '100%';
      return image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: 'image-$imageId');
  }
}
