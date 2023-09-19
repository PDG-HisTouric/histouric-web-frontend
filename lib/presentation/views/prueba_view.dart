import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:histouric_web/config/constants/constants.dart';
import 'package:histouric_web/presentation/js_bridge/js_bridge.dart';
import 'dart:ui_web' as ui;
import 'package:universal_html/html.dart';

import '../../domain/entities/entities.dart';

class PruebaView extends StatefulWidget {
  const PruebaView({super.key});

  @override
  State<PruebaView> createState() => _PruebaViewState();
}

class _PruebaViewState extends State<PruebaView> {
  String time = '';
  String src = '';
  List<HistouricVideoInfo> videosInfo = [];

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

class HtmlVideoContainer extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const HtmlVideoContainer({
    super.key,
    required this.url,
    this.width = 640,
    this.height = 360,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: HtmlVideo(src: url),
      ),
    );
  }
}

class HtmlVideo extends StatelessWidget {
  final String src;

  HtmlVideo({
    super.key,
    required this.src,
  }) {
    ui.platformViewRegistry.registerViewFactory('video-$src', (int viewId) {
      VideoElement videoElement = VideoElement()
        ..controls = true
        ..children.addAll([SourceElement()..src = src]);
      videoElement.style.width = '100%';
      videoElement.style.height = '100%';

      return videoElement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: 'video-$src');
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
        ..children.addAll([SourceElement()..src = src]);
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
