import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// this class for chashed image message and show in chat Screen and till loadind don will show Circular
class CashedImage extends StatelessWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;
  final double height;
  final double width;
  final BoxFit fit;
  CashedImage(
      {this.imageUrl,
      this.isRound = false,
      this.radius = 0,
      this.height,
      this.width,
      this.fit = BoxFit.cover});
  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: fit,
            placeholder: (context, url) => CircularProgressIndicator(),
          ),
        ),
      );
    } catch (ex) {
      print(ex.toString());
    }
  }
}
