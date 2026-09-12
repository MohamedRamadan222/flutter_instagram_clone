import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String imgUrl;
  final double radius;
  final Color? bgColor;
  final Widget? errorWidget;

  const CustomCircleAvatar({
    super.key,
    required this.imgUrl,
    this.radius = 24,
    this.bgColor,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final double diameter = radius * 2;
    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor ?? Colors.grey[200],
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: diameter,
              height: diameter,
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: diameter,
            height: diameter,
            color: Colors.grey[300],
            child: Icon(
              CupertinoIcons.person_fill,
              size: radius,
              color: Colors.white,
              ),
          ),
        ),
      ),
    );
  }
}
