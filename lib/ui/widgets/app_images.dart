import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';
import 'dart:io';


class CameraPlaceholderWidget extends StatelessWidget {
  final Function() onTap;
  final File? file;
  final String? image;

  final double? height;
  final double? width;

  final double size;
  final Color iconColor;
  final Color background;
  const CameraPlaceholderWidget({
    super.key,
    required this.onTap,
    this.file,
    this.image,
    this.height,
    this.size = Sizes.s30,
    this.iconColor = Palette.primary,
    this.width,
  }) : background = Palette.disable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      radius: Sizes.s8,
      child: file != null || image != null
          ? file != null
              ? Container(
                  color: Palette.primary,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.s8),
                    child: Image.file(
                      file!,
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                    ),
                  ),
                )
              : Container(
                  color: Palette.primary,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.s8),
                    child: Image.network(
                      image!,
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                    ),
                  ),
                )
          : Container(
              alignment: Alignment.center,
              height: height,
              width: width,
              decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(Sizes.s8)),
              child: const Icon(
                Icons.camera_alt,
                size: Sizes.s40,
              ),
            ),
    );
  }
}

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final Widget? child;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit fit;

  const CustomImage(
      {Key? key,
      required this.imageUrl,
      this.child,
      this.height,
      this.width,
      this.radius = Sizes.s4,
      this.fit = BoxFit.contain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          child: const CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Palette.error,
        ),
      ),
    );
  }
}
