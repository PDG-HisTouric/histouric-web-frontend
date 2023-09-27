import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../../domain/domain.dart';
import 'rounded_html_image.dart';

class ImageCarousel extends StatefulWidget {
  final List<HistouricImageInfo> imagesInfo;
  const ImageCarousel({super.key, required this.imagesInfo});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentImage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: PageView(
            controller: _pageController,
            children: widget.imagesInfo
                .map(
                  (imageInfo) => RoundedHtmlImage(
                    imageId: imageInfo.id,
                    width: imageInfo.width,
                    height: imageInfo.height,
                    borderRadius: 20,
                    isFromDrive: imageInfo.isFromDrive,
                  ),
                )
                .toList(),
          ),
        ),
        DotsIndicator(
          dotsCount: widget.imagesInfo.length,
          position: _currentImage,
          onTap: (position) {
            _pageController.animateToPage(
              position,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
      ],
    );
  }
}
