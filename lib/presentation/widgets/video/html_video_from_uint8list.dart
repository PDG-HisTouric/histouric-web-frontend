import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:histouric_web/presentation/widgets/video/html_video_container.dart';

class HtmlVideoFromUint8List extends StatelessWidget {
  final Uint8List uint8List;
  final double width;
  final double height;
  final String extension;

  const HtmlVideoFromUint8List({
    super.key,
    required this.uint8List,
    required this.extension,
    this.width = 640,
    this.height = 360,
  });

  @override
  Widget build(BuildContext context) {
    final base64String = base64Encode(uint8List);
    final dataUrl = 'data:video/$extension;base64,$base64String';

    return HtmlVideoContainer(
      url: dataUrl,
      width: width,
      height: height,
    );
  }
}
