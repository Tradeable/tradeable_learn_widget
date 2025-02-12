import 'package:flutter/material.dart';
import '../chart_layer.dart';

class RRLayer extends ChartLayer {
  double value;
  double target;
  double stoploss;
  double startAt;
  double endAt;
  String updatingValue = "";
  Function(double, double, double, double, double)? onUpdate;

  RRLayer({
    required this.value,
    required this.target,
    required this.stoploss,
    required this.startAt,
    required this.endAt,
    this.onUpdate,
  });

  static draw({
    required Canvas canvas,
    required Size size,
    required RRLayer layer,
    required Offset origin,
    required Offset originOffset,
    required double xh,
    required double yh,
    required double yw,
    required double h,
    required double vMax,
    required double vMin,
  }) {
    double boxWidth = 100;
    double boxHeight = 40;
    double rrBoxHeight = 26;

    _drawBox(
        canvas,
        layer.startAt,
        layer.target,
        layer.endAt,
        layer.value,
        yw,
        h,
        xh,
        yh,
        vMax,
        vMin,
        originOffset,
        origin,
        const Color(0xff278829).withOpacity(0.6),
        boxWidth,
        isTarget: true);

    _drawBox(
        canvas,
        layer.startAt,
        layer.stoploss,
        layer.endAt,
        layer.value,
        yw,
        h,
        xh,
        yh,
        vMax,
        vMin,
        originOffset,
        origin,
        const Color(0xffEB0000).withOpacity(0.6),
        boxWidth,
        isStoploss: true);

    double midPoint = ChartLayer.cocaX(layer.startAt, yw, originOffset) +
        (ChartLayer.cocaX(layer.endAt, yw, originOffset) -
                ChartLayer.cocaX(layer.startAt, yw, originOffset)) /
            2;

    _drawTextBox(
        canvas,
        "Target:",
        layer.target.toStringAsFixed(2),
        midPoint,
        layer.target,
        h,
        xh,
        yh,
        vMax,
        vMin,
        originOffset,
        origin,
        boxWidth,
        boxHeight,
        isTarget: true);
    _drawTextBox(
        canvas,
        "Stop-loss:",
        layer.stoploss.toStringAsFixed(2),
        midPoint,
        layer.stoploss,
        h,
        xh,
        yh,
        vMax,
        vMin,
        originOffset,
        origin,
        boxWidth,
        boxHeight,
        isStoploss: true);
    _drawRRBox(
        canvas,
        "RR:",
        ((layer.target - layer.value) / (layer.value - layer.stoploss))
            .abs()
            .toStringAsFixed(2),
        midPoint,
        layer.value,
        h,
        xh,
        yh,
        vMax,
        vMin,
        originOffset,
        origin,
        boxWidth,
        rrBoxHeight);
  }

  static void _drawBox(
      Canvas canvas,
      double start,
      double top,
      double end,
      double bottom,
      double yw,
      double h,
      double xh,
      double yh,
      double vMax,
      double vMin,
      Offset originOffset,
      Offset origin,
      Color color,
      double width,
      {bool isTarget = false,
      bool isStoploss = false}) {
    double midPoint = ChartLayer.cocaX(start, yw, originOffset) +
        (ChartLayer.cocaX(end, yw, originOffset) -
                ChartLayer.cocaX(start, yw, originOffset)) /
            2;

    double boxX = midPoint - width / 2;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(
          boxX,
          ChartLayer.cocaY(top, h, xh, yh, vMax, vMin, originOffset, origin),
          boxX + width,
          ChartLayer.cocaY(bottom, h, xh, yh, vMax, vMin, originOffset, origin),
        ),
        topLeft: isTarget ? const Radius.circular(6) : Radius.zero,
        topRight: isTarget ? const Radius.circular(6) : Radius.zero,
        bottomLeft: isStoploss ? const Radius.circular(6) : Radius.zero,
        bottomRight: isStoploss ? const Radius.circular(6) : Radius.zero,
      ),
      Paint()..color = color,
    );
  }

  static void _drawTextBox(
      Canvas canvas,
      String label,
      String value,
      double midPoint,
      double yValue,
      double h,
      double xh,
      double yh,
      double vMax,
      double vMin,
      Offset originOffset,
      Offset origin,
      double width,
      double height,
      {bool isTarget = false,
      bool isStoploss = false}) {
    double boxX = midPoint - width / 2;
    double boxY =
        ChartLayer.cocaY(yValue, h, xh, yh, vMax, vMin, originOffset, origin) -
            height / 2;

    canvas.drawRRect(
      RRect.fromLTRBR(
        boxX,
        boxY,
        boxX + width,
        boxY + height,
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xff404040),
    );

    TextPainter labelPainter = _getTextPainter(
        label, const TextStyle(color: Color(0xffD1D1D1), fontSize: 13));
    TextPainter valuePainter = _getTextPainter(
        value, const TextStyle(color: Colors.white, fontSize: 13));

    labelPainter.paint(canvas, Offset(boxX + 8, boxY + 4));
    valuePainter.paint(canvas, Offset(boxX + 8, boxY + height / 2));
  }

  static void _drawRRBox(
      Canvas canvas,
      String label,
      String value,
      double midPoint,
      double yValue,
      double h,
      double xh,
      double yh,
      double vMax,
      double vMin,
      Offset originOffset,
      Offset origin,
      double width,
      double height) {
    double boxX = midPoint - width / 2;
    double boxY =
        ChartLayer.cocaY(yValue, h, xh, yh, vMax, vMin, originOffset, origin) -
            height / 2;

    canvas.drawRRect(
      RRect.fromLTRBR(
        boxX,
        boxY,
        boxX + width,
        boxY + height,
        const Radius.circular(0),
      ),
      Paint()..color = const Color(0xff404040),
    );

    TextPainter labelPainter = _getTextPainter(
        label, const TextStyle(color: Color(0xffD1D1D1), fontSize: 13));
    TextPainter valuePainter = _getTextPainter(
        value, const TextStyle(color: Colors.white, fontSize: 13));

    labelPainter.paint(
        canvas, Offset(boxX + 8, boxY + (height - labelPainter.height) / 2));
    valuePainter.paint(
        canvas,
        Offset(boxX + width - valuePainter.width - 8,
            boxY + (height - valuePainter.height) / 2));
  }

  static TextPainter _getTextPainter(String text, TextStyle style) {
    return TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
  }
}
