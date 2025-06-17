import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;
  final List<String>? imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PhotoViewController controller;
  late PageController pageController;
  int currentIndex = 0;
  double scale = 1.0;

  @override
  void initState() {
    super.initState();
    controller = PhotoViewController();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  List<String> get images {
    if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) {
      return widget.imageUrls!;
    }
    return [widget.imageUrl];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (images.length == 1)
          PhotoView(
            imageProvider: NetworkImage(images[0]),
            controller: controller,
            heroAttributes: widget.heroTag != null
                ? PhotoViewHeroAttributes(tag: widget.heroTag!)
                : null,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: const BoxDecoration(
              color: Colors.black87,
            ),
            enableRotation: false,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.broken_image,
                color: Colors.white,
                size: 50,
              ),
            ),
          )
        else
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black87,
            ),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(images[index]),
                heroAttributes: PhotoViewHeroAttributes(
                  tag: 'image_${images[index]}',
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                initialScale: PhotoViewComputedScale.contained,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              );
            },
            itemCount: images.length,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            pageController: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '${currentIndex + 1} / ${images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
