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
  bool _isTooltipVisible = false;

  void _showTooltip() {
    if (_isTooltipVisible) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isTooltipVisible = false;
      return;
    }

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
            width: MediaQuery.of(context).size.width - 200,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
    _isTooltipVisible = true;

    Future.delayed(const Duration(seconds: 5), () {
      if (_overlayEntry != null) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _isTooltipVisible = false;
      }
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
