import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CandlePartMatchPainter extends CustomPainter {
  final List<String> pairFor;
  final double canvasHeight;
  final double candleWidth;
  final double shadowWidth;
  final double candleVerticalPadding;
  final double canvasPadding;
  final bool isBullish;
  final double optionHolderWidth;
  final double optionHolderHeight;
  final ThemeData theme;

  CandlePartMatchPainter(
      {required this.pairFor,
      required this.canvasHeight,
      required this.candleWidth,
      required this.shadowWidth,
      required this.candleVerticalPadding,
      required this.canvasPadding,
      required this.isBullish,
      required this.optionHolderWidth,
      required this.optionHolderHeight,
      required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    size = Size(size.width, canvasHeight);
    final rect = Rect.fromLTWH(0, 0, size.width, canvasHeight);
    canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.transparent);
    canvas.clipRect(rect);
    canvas.save();

    drawCandle(
        canvas: canvas, size: size, isCandleGreen: isBullish, rect: rect);

    if (pairFor.contains("High")) {
      drawAnswerBox(
          canvas: canvas, size: size, factor: 0, alignFromRight: false);
    }

    if (pairFor.contains("Wick")) {
      drawAnswerBox(
          canvas: canvas, size: size, factor: 1, alignFromRight: true);
    }
    if (pairFor.contains("Close")) {
      isBullish
          ? drawAnswerBox(
              canvas: canvas, size: size, factor: 2, alignFromRight: false)
          : drawAnswerBox(
              canvas: canvas, size: size, factor: 6, alignFromRight: false);
    }
    if (pairFor.contains("Body")) {
      drawAnswerBox(
          canvas: canvas, size: size, factor: 4, alignFromRight: true);
    }
    if (pairFor.contains("Open")) {
      isBullish
          ? drawAnswerBox(
              canvas: canvas, size: size, factor: 6, alignFromRight: false)
          : drawAnswerBox(
              canvas: canvas, size: size, factor: 2, alignFromRight: false);
    }
    if (pairFor.contains("Tail")) {
      drawAnswerBox(
          canvas: canvas, size: size, factor: 7, alignFromRight: true);
    }
    if (pairFor.contains("Low")) {
      drawAnswerBox(
          canvas: canvas, size: size, factor: 8, alignFromRight: false);
    }

    canvas.restore();
  }

  void drawAnswerBox({
    required Canvas canvas,
    required Size size,
    required int factor,
    required bool alignFromRight,
  }) {
    final borderPaint = Paint()
      ..color = theme.customColors.borderColorPrimary.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();

    double candleAreaHeight =
        size.height - 2 * (candleVerticalPadding + canvasPadding);
    double spaceToLeaveAtTop = canvasPadding + candleVerticalPadding;
    double pointingAt = spaceToLeaveAtTop + (candleAreaHeight / 8) * factor;
    double candleCenter = size.width / 2;

    double boxLeft, boxRight;

    if (alignFromRight) {
      boxRight = size.width - canvasPadding;
      boxLeft = boxRight - optionHolderWidth;
    } else {
      boxLeft = canvasPadding;
      boxRight = boxLeft + optionHolderWidth;
    }

    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    double startX, startY;

    startX = boxLeft;
    startY = pointingAt - optionHolderHeight / 2;

    while (startX < boxRight) {
      path.moveTo(startX, startY);
      path.lineTo(startX + dashWidth, startY);
      startX += dashWidth + dashSpace;
    }
    canvas.drawPath(path, borderPaint);

    path.reset();
    startX = boxLeft;
    startY = pointingAt + optionHolderHeight / 2;

    while (startX < boxRight) {
      path.moveTo(startX, startY);
      path.lineTo(startX + dashWidth, startY);
      startX += dashWidth + dashSpace;
    }
    canvas.drawPath(path, borderPaint);

    path.reset();
    startX = boxLeft;
    startY = pointingAt - optionHolderHeight / 2;

    while (startY < pointingAt + optionHolderHeight / 2) {
      path.moveTo(boxLeft, startY);
      path.lineTo(boxLeft, startY + dashWidth);
      startY += dashWidth + dashSpace;
    }
    canvas.drawPath(path, borderPaint);

    path.reset();
    startY = pointingAt - optionHolderHeight / 2;

    while (startY < pointingAt + optionHolderHeight / 2) {
      path.moveTo(boxRight, startY);
      path.lineTo(boxRight, startY + dashWidth);
      startY += dashWidth + dashSpace;
    }
    canvas.drawPath(path, borderPaint);

    final linePaint = Paint()
      ..color = theme.dividerColor
      ..strokeWidth = 1.2;

    final p1 = alignFromRight
        ? Offset(boxLeft - 10, pointingAt)
        : Offset(boxRight + 10, pointingAt);
    final p2 = Offset(
        alignFromRight ? 10 + candleCenter : candleCenter - 10, pointingAt);

    canvas.drawLine(p1, p2, linePaint);
  }

  drawCandle({
    required Canvas canvas,
    required Size size,
    required bool isCandleGreen,
    required Rect rect,
  }) {
    final paint = Paint()..color = isCandleGreen ? Colors.green : Colors.red;
    double candleAreaHeight =
        size.height - 2 * (candleVerticalPadding + canvasPadding);
    double candleCenter = size.width / 2;

    canvas.drawRRect(
        RRect.fromLTRBR(
            candleCenter - candleWidth / 2,
            canvasPadding + candleVerticalPadding + candleAreaHeight * 0.25,
            candleCenter + candleWidth / 2,
            canvasPadding + candleVerticalPadding + candleAreaHeight * 0.75,
            const Radius.circular(0)),
        paint);
    canvas.drawRRect(
        RRect.fromLTRBR(
            candleCenter - shadowWidth / 2,
            canvasPadding + candleVerticalPadding,
            candleCenter + shadowWidth / 2,
            rect.bottom - (canvasPadding + candleVerticalPadding),
            const Radius.circular(0)),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
