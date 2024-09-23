import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class DottedBorderWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;

  const DottedBorderWidget(
      {super.key, required this.backgroundColor, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      width: 70,
      decoration: BoxDecoration(color: backgroundColor),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: CustomPaint(
        painter: DashedBorderPainter(borderColor),
        child: Center(
          child: Text(
            "         ",
            style: textStyles.largeBold,
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color borderColor;

  DashedBorderPainter(this.borderColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 10.0;
    const dashSpace = 5.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(6)));

    final dashPath = _createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path path, double dashWidth, double dashSpace) {
    final Path dashedPath = Path();
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final offset1 = pathMetric.getTangentForOffset(distance)?.position;
        final offset2 =
            pathMetric.getTangentForOffset(distance + dashWidth)?.position;

        if (offset1 != null && offset2 != null) {
          dashedPath.moveTo(offset1.dx, offset1.dy);
          dashedPath.lineTo(offset2.dx, offset2.dy);
        }

        distance += dashWidth + dashSpace;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
