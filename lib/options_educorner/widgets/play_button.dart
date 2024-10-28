import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  final VoidCallback onPressed;

  const PlayButton({required this.onPressed, super.key});

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.9).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: CustomPaint(
              painter: TrianglePainter(isPressed: _isPressed),
              size: const Size(90, 90),
            ),
          );
        },
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final bool isPressed;

  TrianglePainter({required this.isPressed});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xffFF4E4E)
      ..style = PaintingStyle.fill;

    final Paint bottomPaint = Paint()
      ..color = const Color(0xffFF2222)
      ..style = PaintingStyle.fill;

    final double offset = isPressed ? 4.0 : 0.0;

    final Path path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.25)
      ..lineTo(size.width * 0.75, size.height * 0.5)
      ..lineTo(size.width * 0.25, size.height * 0.75 + offset)
      ..close();

    final Path bottomPath = Path()
      ..moveTo(size.width * 0.25, size.height * 0.25)
      ..lineTo(size.width * 0.75, size.height * 0.52)
      ..lineTo(size.width * 0.25, size.height * 0.82 - offset)
      ..close();

    canvas.drawPath(bottomPath, bottomPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
