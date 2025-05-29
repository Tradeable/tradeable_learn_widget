import 'package:flutter/material.dart';

class TapTooltip extends StatefulWidget {
  final Widget child;
  final String message;

  const TapTooltip({super.key, required this.child, required this.message});

  @override
  State<TapTooltip> createState() => _TapTooltipState();
}

class _TapTooltipState extends State<TapTooltip> {
  OverlayEntry? _overlayEntry;

  void _showTooltip() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height / 2 - 16,
        left: offset.dx + size.width + 8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 5), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTooltip,
      child: widget.child,
    );
  }
}
