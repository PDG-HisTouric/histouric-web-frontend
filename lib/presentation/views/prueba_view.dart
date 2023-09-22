import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:histouric_web/config/constants/constants.dart';
import 'package:histouric_web/presentation/js_bridge/js_bridge.dart';

import '../../config/plugins/plugins.dart';
import '../../domain/entities/entities.dart';
import '../widgets/audio/audio.dart';
import '../widgets/video/video.dart';
import '../widgets/widgets.dart';

class PruebaView extends StatefulWidget {
  const PruebaView({super.key});

  @override
  State<PruebaView> createState() => _PruebaViewState();
}

class _PruebaViewState extends State<PruebaView> {
  String time = '';
  String src = '';
  List<HistouricVideoInfo> videosInfo = [];
  AbstractFilePicker filePicker = FilePickerImpl();
  List<Uint8List> images = [];
  List<String> imagesExtensions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(time),
            HtmlAudioContainer(
              src: src,
              width: 400,
              onChangeAudioTime: _onChangeAudioTime,
            ),
            ElevatedButton(
              onPressed: () {
                _loadAudioFromDrive();
              },
              child: const Text('Cargar audio de Drive'),
            ),
            ElevatedButton(
              onPressed: () {
                _loadVideoFromDrive();
              },
              child: const Text('Cargar video de Drive'),
            ),
            Column(
              children: videosInfo
                  .map(
                    (videoInfo) => Row(
                      children: [
                        const Spacer(),
                        HtmlVideoContainer(
                          url: videoInfo.url,
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                  .toList(),
            ),
            Wrap(
              children: [
                for (int i = 0; i < images.length; i++)
                  HtmlImageFromUint8List(
                    uint8List: images[i],
                    extension: imagesExtensions[i],
                  ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  final result = await filePicker.selectImages();
                  setState(() {
                    images = result.$1;
                    imagesExtensions = result.$2;
                  });
                },
                child: const Text('Abrir file picker de imágenes')),
          ],
        ),
      ),
    );
  }

  void _onChangeAudioTime(String currentTime) {
    setState(() {
      time = currentTime;
    });
  }

  void _loadAudioFromDrive() {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.audio,
    );

    _waitUntilThePickerIsOpen().then((value) {
      _waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final audioId = GooglePicker.callGetSelectedAudioId();
          setState(() {
            src = 'https://drive.google.com/uc?export=download&id=$audioId';
          });
        }
      });
    });
  }

  void _loadVideoFromDrive() {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.video,
    );

    GooglePicker.waitUntilThePickerIsOpen().then((value) {
      GooglePicker.waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          setState(() {
            videosInfo = GooglePicker.getInfoOfSelectedVideos();
          });
        }
      });
    });
  }

  Future<void> _waitUntilThePickerIsOpen() async {
    while (!GooglePicker.callGetIsThereAnError() &&
        !GooglePicker.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _waitUntilThePickerIsClosed() async {
    while (GooglePicker.callGetIsPickerOpen()) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
