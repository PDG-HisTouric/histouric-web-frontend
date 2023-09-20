import 'package:flutter/material.dart';

import 'html_audio.dart';

class HtmlAudioContainer extends StatelessWidget {
  final String src;
  final double width;
  final void Function(String currentTime) onChangeAudioTime;

  const HtmlAudioContainer({
    super.key,
    required this.src,
    required this.width,
    required this.onChangeAudioTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        height: 60,
        child: HtmlAudio(
          src: src,
          onChangeAudioTime: onChangeAudioTime,
        ),
      ),
    );
  }
}
