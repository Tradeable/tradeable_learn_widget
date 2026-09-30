import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/sahi/content/journey_content.dart';

/// Fullscreen preview for infographic images, with pinch zoom and swipe
/// between the images of the same block.
Future<void> showJourneyImageViewer(
  BuildContext context,
  List<JourneyContentImage> images, {
  int initialIndex = 0,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black,
      pageBuilder: (_, __, ___) =>
          JourneyImageViewer(images: images, initialIndex: initialIndex),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

class JourneyImageViewer extends StatefulWidget {
  final List<JourneyContentImage> images;
  final int initialIndex;

  const JourneyImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<JourneyImageViewer> createState() => _JourneyImageViewerState();
}

class _JourneyImageViewerState extends State<JourneyImageViewer> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex.clamp(0, widget.images.length - 1),
  );
  late int _index = _controller.initialPage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final isNetwork = image.image.startsWith('http');
              return GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: isNetwork
                        ? Image.network(image.image, fit: BoxFit.contain)
                        : Image.asset(image.image, fit: BoxFit.contain),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 24,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${_index + 1} / ${widget.images.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
