import 'package:flutter/material.dart';

class TrapezoidPainter extends CustomPainter {
  final String value;
  final Color? textColor;
  final Color? bgColor;

  const TrapezoidPainter({required this.value, this.textColor, this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = bgColor ?? Colors.white;

    final Path path = Path()
      ..moveTo(0, 40)
      ..lineTo(size.width * 0.25, 0)
      ..lineTo(size.width * 0.75, 0)
      ..lineTo(size.width, 40)
      ..close();

    canvas.drawPath(path, paint);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
            color: textColor ?? Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
          (size.width - textPainter.width) / 2, (40 - textPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
