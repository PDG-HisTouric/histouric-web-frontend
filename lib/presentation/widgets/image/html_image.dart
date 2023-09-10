import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';

class HtmlImage extends StatelessWidget {
  final String url;
  final bool isFromDrive;

  HtmlImage({super.key, required this.url, required this.isFromDrive}) {
    ui.platformViewRegistry.registerViewFactory('image-$url', (int viewId) {
      var image = isFromDrive
          ? ImageElement(src: 'https://drive.google.com/uc?id=$url')
          : ImageElement(src: url);
      image.style.height = '100%';
      image.style.width = '100%';
      return image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: 'image-$url');
  }
}
