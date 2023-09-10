import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'rounded_html_image.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> filesIds;
  const ImageCarousel({super.key, required this.filesIds});

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: PageView(
              controller: _pageController,
              children: widget.filesIds
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: RoundedHtmlImage(
                        imageId: e,
                        width: 400,
                        height: 400,
                        borderRadius: 20,
                        isFromDrive: false,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          DotsIndicator(
              dotsCount: widget.filesIds.length,
              position: _currentImage,
              onTap: (position) {
                _pageController.animateToPage(
                  position,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }),
        ],
      ),
    );
  }
}
