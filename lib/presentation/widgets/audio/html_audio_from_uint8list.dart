import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'html_audio_container.dart';

class HtmlAudioFromUint8List extends StatelessWidget {
  final Uint8List uint8List;
  final double width;
  final String extension;
  final void Function(String currentTime) onChangeAudioTime;

  const HtmlAudioFromUint8List({
    super.key,
    required this.uint8List,
    required this.onChangeAudioTime,
    required this.extension,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final base64String = base64Encode(uint8List);
    final dataUrl = 'data:audio/$extension;base64,$base64String';

    return HtmlAudioContainer(
      src: dataUrl,
      width: width,
      onChangeAudioTime: onChangeAudioTime,
    );
  }
}
