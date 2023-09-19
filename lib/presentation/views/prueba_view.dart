import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:histouric_web/config/constants/constants.dart';
import 'package:histouric_web/presentation/js_bridge/js_bridge.dart';
import 'dart:ui_web' as ui;
import 'package:universal_html/html.dart';

class PruebaView extends StatefulWidget {
  const PruebaView({super.key});

  @override
  State<PruebaView> createState() => _PruebaViewState();
}

class _PruebaViewState extends State<PruebaView> {
  String time = '';
  String src = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Text(time),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1)),
            width: 400,
            height: 60,
            child: HtmlAudio(
              src: src,
              onChangeAudioTime: _onChangeAudioTime,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _loadAudioFromDrive(MediaType.audio);
            },
            child: const Text('Cargar audio de Drive'),
          ),
        ],
      )),
    );
  }

  void _onChangeAudioTime(String currentTime) {
    setState(() {
      time = currentTime;
    });
  }

  void _loadAudioFromDrive(MediaType temp) {
    GooglePicker.callFilePicker(
      apiKey: Environment.pickerApiKey,
      appId: Environment.pickerApiAppId,
      mediaType: temp,
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

class HtmlAudio extends StatelessWidget {
  final void Function(String currentTime) onChangeAudioTime;
  final String src;

  HtmlAudio({super.key, required this.src, required this.onChangeAudioTime}) {
    ui.platformViewRegistry.registerViewFactory('audio-$src', (int viewId) {
      AudioElement audioElement = AudioElement()
        ..addEventListener(
            'timeupdate',
            (event) => onChangeAudioTime(
                (event.target as AudioElement).currentTime.toString()))
        ..controls = true
        ..children.addAll([
          SourceElement()
            ..src = src
            ..type = 'audio/mp3',
        ]);
      audioElement.style.width = '100%';
      audioElement.style.height = '100%';

      return audioElement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: 'audio-$src');
  }
}
