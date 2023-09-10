import 'package:flutter/material.dart';

import 'star_painter.dart';

class BackgroundFigures extends StatelessWidget {
  const BackgroundFigures({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Positioned(
          top: 50,
          left: 50,
          child: _buildStar(30.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          top: 150,
          right: 50,
          child: _buildStar(20.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 100,
          left: 150,
          child: _buildCircle(100.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 80,
          right: 200,
          child: _buildStar(25.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          top: 250,
          left: 200,
          child: _buildStar(70.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          top: 350,
          right: 100,
          child: _buildStar(35.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 250,
          left: 100,
          child: _buildStar(50.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 300,
          right: 150,
          child: _buildStar(30.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          top: 400,
          left: 250,
          child: _buildCircle(80.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          top: 500,
          right: 150,
          child: _buildStar(50.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 400,
          left: 100,
          child: _buildCircle(40.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 450,
          right: 200,
          child: _buildStar(20.0, colorScheme.onPrimary.withOpacity(0.2)),
        ),
      ],
    );
  }

  Widget _buildStar(double size, Color color) {
    return CustomPaint(painter: StarPainter(size: size, color: color));
  }

  Widget _buildCircle(double radius, Color color) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
