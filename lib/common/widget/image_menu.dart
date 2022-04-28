import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageMenuWidget extends StatelessWidget {
  final String src;
  final double size;
  final VoidCallback onTap;

  const ImageMenuWidget(this.src, this.size, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
            onTap: onTap,
            child: Image.asset(
              src,
              width: size,
              height: size,
            )));
  }
}
