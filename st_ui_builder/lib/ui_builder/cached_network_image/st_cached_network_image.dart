import 'dart:io';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:st_ui_builder/config/colors.dart';
import 'package:st_ui_builder/ui_builder/cached_network_image/image_service.dart';

class StCachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxShape shape;
  final BoxFit? fit;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const StCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = double.infinity,
    this.width = double.infinity,
    this.shape = BoxShape.rectangle,
    this.fit,
    this.errorWidget,
    this.loadingWidget,
  });

  @override
  State<StCachedNetworkImage> createState() => _StCachedNetworkImageState();
}

class _StCachedNetworkImageState extends State<StCachedNetworkImage> {
  late final ImageService _imageService = ImageService();
  bool _loading = true;
  bool _hasError = false;
  File? _image;

  Future<void> _getImage() async {
    try {
      setState(() {
        _loading = true;
        _hasError = false;
      });

      final image = await _imageService.getImage(url: widget.imageUrl);

      if (image == null) {
        setState(() {
          _loading = false;
          _hasError = true;
          _image = null;
        });
      } else {
        setState(() {
          _loading = false;
          _hasError = false;
          _image = image;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _hasError = true;
        _image = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_getImage);
  }

  @override
  void didUpdateWidget(covariant StCachedNetworkImage oldWidget) {
    if (oldWidget.imageUrl != widget.imageUrl) {
      Future.microtask(_getImage);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: widget.loadingWidget ??
            Shimmer.fromColors(
              baseColor: StColors.black.withOpacity(.7),
              highlightColor: Colors.blueGrey.shade900,
              child: Container(
                width: widget.width,
                height: widget.height,
                color: StColors.black.withOpacity(.7),
              ),
            ),
      );
    }

    if (!_hasError && _image != null) {
      return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          shape: widget.shape,
          image: DecorationImage(
            fit: widget.fit,
            image: FileImage(_image!),
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: widget.errorWidget ??
          Image.asset(
            'assets/images/logo.png',
            height: widget.height,
            width: widget.width,
          ),
    );
  }
}
