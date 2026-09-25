import 'package:flutter/material.dart';

class VideoBanner extends StatelessWidget {
  final VoidCallback onTap;
  final ImageProvider image;
  final double? height;
  final double? borderRadius;
  final Widget iconWidget;

  const VideoBanner({
    super.key,
    required this.onTap,
    required this.image,
    this.height,
    this.borderRadius,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 16),
      child: Stack(
        children: [
          Image(
            image: image,
            height: height ?? 280,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
          Container(
            color: Colors.black.withAlpha((0.2 * 255).round()),
            height: height ?? 280,
          ),
          Positioned.fill(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: iconWidget,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
