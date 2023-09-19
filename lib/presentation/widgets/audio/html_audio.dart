import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'dart:ui_web' as ui;

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
