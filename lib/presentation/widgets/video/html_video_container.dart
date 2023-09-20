import 'package:flutter/material.dart';

import 'html_video.dart';

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
