import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'rounded_html_image.dart';

class HtmlImageFromUint8List extends StatelessWidget {
  final Uint8List uint8List;
  final double width;
  final double height;
  final String extension;

  const HtmlImageFromUint8List({
    super.key,
    required this.uint8List,
    this.width = 300,
    this.height = 300,
    required this.extension,
  });

  @override
  Widget build(BuildContext context) {
    final base64String = base64Encode(uint8List);
    final dataUrl = 'data:image/$extension;base64,$base64String';

    return RoundedHtmlImage(
      imageId: dataUrl,
      width: width,
      height: height,
      isFromDrive: false,
    );
  }
}
