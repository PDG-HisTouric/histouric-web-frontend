import 'package:flutter/material.dart';

import 'html_image.dart';

class RoundedHtmlImage extends StatelessWidget {
  final String imageId;
  final double width;
  final double height;
  final double borderRadius;

  const RoundedHtmlImage({
    super.key,
    required this.imageId,
    this.width = 300,
    this.height = 300,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: FittedBox(
          fit: BoxFit.none,
          child: SizedBox(
            height: height,
            width: width,
            child: HtmlImage(url: imageId),
          ),
        ),
      ),
    );
  }
}
