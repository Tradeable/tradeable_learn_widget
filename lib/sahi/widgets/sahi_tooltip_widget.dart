import 'package:flutter/material.dart';

class SahiTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final double maxWidth;
  final double? maxHeight;

  const SahiTooltip({
    super.key,
    required this.child,
    required this.message,
    this.maxWidth = 260,
    this.maxHeight,
  });

  @override
  State<SahiTooltip> createState() => _SahiTooltipState();
}

class _SahiTooltipState extends State<SahiTooltip> {
  OverlayEntry? _overlayEntry;
  bool _isTooltipVisible = false;

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isTooltipVisible = false;
  }

  void _showTooltip() {
    if (_isTooltipVisible) {
      _hideTooltip();
      return;
    }

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;

    double left = offset.dx + size.width + 8;

    if (left + widget.maxWidth > screenWidth - 16) {
      left = screenWidth - widget.maxWidth - 16;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height / 2 - 20,
        left: left,
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: widget.maxWidth,
              maxHeight: widget.maxHeight ?? double.infinity,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    _isTooltipVisible = true;

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isTooltipVisible) {
        _hideTooltip();
      }
    });
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTooltip,
      child: widget.child,
    );
  }
}
