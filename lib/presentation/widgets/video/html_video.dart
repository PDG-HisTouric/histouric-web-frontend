import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'dart:ui_web' as ui;

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
