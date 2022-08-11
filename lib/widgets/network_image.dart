import 'package:flutter/material.dart';

///
/// Network image builder with the safe error handing
///

class NetworkImageWidget extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const NetworkImageWidget(
      {Key? key, required this.url, this.width, this.height, this.fit})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(url);
    return Image.network(url, width: width, height: height,
        frameBuilder: (context, child, frame, builder) {
      return frame == null
          ? const Center(
              child: SizedBox(
                  width: 50, height: 50, child: CircularProgressIndicator()))
          : child;
    }, errorBuilder: (context, error, stackTrace) {
      print('Load failed! this=${context.toString()}');
      return const Icon(
        Icons.error_rounded,
        color: Colors.red,
      );
    }, fit: fit);
  }
}
