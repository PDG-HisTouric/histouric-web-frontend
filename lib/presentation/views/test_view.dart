import 'package:flutter/material.dart';
import 'package:histouric_web/domain/entities/entities.dart';

import '../../config/constants/constants.dart';
import '../js_bridge/js_bridge.dart';
import '../widgets/widgets.dart';

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

  List<HistouricImageInfo> imagesInfo = [];

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
                    imagesInfo = [
                      ...imagesInfo,
                      ...JSHelper.callGetSelectedFilesIds()
                    ];
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            if (imagesInfo.isEmpty)
              const Text(
                'No files selected',
                style: TextStyle(color: Colors.red),
              ),
            if (imagesInfo.isNotEmpty) ...[
              const Text('Selected files:'),
              const SizedBox(height: 20),
            ],
            if (imagesInfo.isNotEmpty)
              Wrap(
                children: imagesInfo
                    .map(
                      (imageInfo) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 400,
                          height: 400,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              height: imageInfo.height,
                              width: imageInfo.width,
                              child: HtmlImage(
                                url: imageInfo.id,
                                isFromDrive: true,
                              ),
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
