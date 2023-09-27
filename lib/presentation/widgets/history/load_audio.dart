import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../config/config.dart';
import '../../js_bridge/js_bridge.dart';
import '../audio/audio.dart';

class LoadAudio extends StatefulWidget {
  const LoadAudio();

  @override
  State<LoadAudio> createState() => _LoadAudioState();
}

class _LoadAudioState extends State<LoadAudio> {
  String src = '';
  String time = '';
  Uint8List? audio;
  String? audioName;
  String? audioExtension;
  String selectedAudioPath = "";
  bool isAudioFromFilePicker = false;
  AbstractFilePicker filePicker = FilePickerImpl();

  void _loadAudioFromDrive() {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: MediaType.audio,
    );
    GooglePicker.waitUntilThePickerIsOpen().then((value) {
      GooglePicker.waitUntilThePickerIsClosed().then((value) {
        if (!GooglePicker.callGetIsThereAnError()) {
          final audioId = GooglePicker.callGetSelectedAudioId();
          setState(() {
            isAudioFromFilePicker = false;
            src = 'https://drive.google.com/uc?export=view&id=$audioId';
          });
        }
      });
    });
  }

  void _onChangeAudioTime(String currentTime) {
    setState(() {
      time = currentTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isAudioFromFilePicker)
          HtmlAudioContainer(
            src: src,
            width: 400,
            onChangeAudioTime: _onChangeAudioTime,
          ),
        if (isAudioFromFilePicker)
          HtmlAudioFromUint8List(
            uint8List: audio!,
            extension: audioExtension!,
            width: 400,
            onChangeAudioTime: _onChangeAudioTime,
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                filePicker.selectAudio().then((result) {
                  setState(() {
                    isAudioFromFilePicker = true;
                    audio = result.$1;
                    audioExtension = result.$2;
                    audioName = result.$3;
                  });
                });
              },
              label: const Text("From File Explorer"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: _loadAudioFromDrive,
              label: const Text("From Google Drive"),
            ),
          ],
        ),
      ],
    );
  }
}
