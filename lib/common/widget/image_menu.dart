import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageMenuWidget extends StatelessWidget {
  final String src;
  final double size;
  final VoidCallback onTap;
  final Function(TapDownDetails details)? onTapWithDeatil;

  const ImageMenuWidget(this.src, this.size,
      {required this.onTap, this.onTapWithDeatil});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
            onTap: onTap,
            onTapDown: (TapDownDetails details) {
              if (onTapWithDeatil != null) {
                onTapWithDeatil!(details);
              }
            },
            child: Image.asset(
              src,
              width: size,
              height: size,
            )));
  }
}
