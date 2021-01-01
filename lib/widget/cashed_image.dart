import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// this class for chashed image message and show in chat Screen and till loadind don will show Circular
class CashedImage extends StatelessWidget {
  final String url;
  CashedImage({@required this.url});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => CircularProgressIndicator(),
        ),
      ),
    );
  }
}
