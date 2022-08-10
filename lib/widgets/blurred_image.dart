import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredImage extends StatelessWidget {
  final Image image;
  const BlurredImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Stack(
        children: [
          Container(
            height: 255,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black.withAlpha(100),
                  Colors.transparent,
                ],
                stops: const [0, 0.95, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(0, -constraint.constrainHeight(200) * 0.05),
              child: Transform.scale(
                scaleX: 1.5,
                scaleY: 0.95,
                child: image,
              ),
            ),
          ),
        ],
      );
    });
  }
}
