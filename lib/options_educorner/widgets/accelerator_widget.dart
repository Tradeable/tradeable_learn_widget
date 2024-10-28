import 'dart:math';
import 'package:flutter/material.dart';

class AcceleratorWidget extends StatefulWidget {
  final VoidCallback onPress;
  final VoidCallback onRelease;

  const AcceleratorWidget({
    super.key,
    required this.onPress,
    required this.onRelease,
  });

  @override
  State<AcceleratorWidget> createState() => _AcceleratorWidgetState();
}

class _AcceleratorWidgetState extends State<AcceleratorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    widget.onPress(); // Call the onPress function from the parent
    _controller.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    widget.onRelease(); // Call the onRelease function from the parent
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => _onPointerDown(const PointerDownEvent()),
      onPanEnd: (details) => _onPointerUp(const PointerUpEvent()),
      child: MouseRegion(
        onEnter: (event) => _onPointerDown(const PointerDownEvent()),
        onExit: (event) => _onPointerUp(const PointerUpEvent()),
        child: SizedBox(
          width: 200,
          height: 100,
          child: CustomPaint(
            painter: _AcceleratorPainter(animation: _animation),
          ),
        ),
      ),
    );
  }
}

class _AcceleratorPainter extends CustomPainter {
  final Animation<double> animation;

  _AcceleratorPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint baseLinePaint = Paint()
      ..color = const Color(0xFF363B3F)
      ..strokeWidth = 6;

    final Paint verticalLinePaint = Paint()
      ..color = const Color(0xFFEBB746)
      ..strokeWidth = 8;

    final Paint connectingLinePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF484D51), Color(0xFF6A6E74)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    final Paint circlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    double horizontalDividerLength = size.width;
    double verticalDividerHeight = 20;
    double animatedHeight = verticalDividerHeight * (1 - animation.value);

    Offset startHorizontal = Offset(0, size.height);
    Offset endHorizontal = Offset(horizontalDividerLength, size.height);
    canvas.drawLine(startHorizontal, endHorizontal, baseLinePaint);

    Offset startTriangle = startHorizontal;
    Offset endTriangle =
        Offset(horizontalDividerLength, size.height - animatedHeight * 4);
    canvas.drawLine(startTriangle, endTriangle, connectingLinePaint);

    Offset topVertical =
        Offset(horizontalDividerLength / 2, size.height - animatedHeight * 1.4);
    canvas.drawLine(topVertical,
        Offset(horizontalDividerLength / 2, size.height), verticalLinePaint);

    double blueLineOffset = 14;
    Offset blueLineStart =
        Offset(startHorizontal.dx, startHorizontal.dy - blueLineOffset);
    Offset blueLineEnd =
        Offset(endTriangle.dx, endTriangle.dy - blueLineOffset);

    double circleRadius = 8;
    double distanceBetweenCircles = 30;

    double dx = blueLineStart.dx;
    double dy = blueLineStart.dy;
    double angle = (blueLineEnd - blueLineStart).direction;

    while (dx <= blueLineEnd.dx) {
      double circleCenterX = dx + circleRadius * cos(angle);
      double circleCenterY = dy + circleRadius * sin(angle);

      canvas.drawCircle(
        Offset(circleCenterX, circleCenterY),
        circleRadius,
        circlePaint,
      );

      dx += distanceBetweenCircles;
      dy += distanceBetweenCircles * sin(angle);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
