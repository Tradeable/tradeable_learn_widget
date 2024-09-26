import 'package:flutter/material.dart';
import '../chart_layer.dart';

class LineLayer extends ChartLayer {
  final String id;
  double value;
  final Color color;
  final Color textColor;
  final Function(double)? onUpdate;

  LineLayer(
      {required this.id,
      required this.value,
      required this.color,
      required this.textColor,
      this.onUpdate});

  static draw(
      {required Canvas canvas,
      required Size size,
      required LineLayer layer,
      required Offset origin,
      required Offset originOffset,
      required double xh,
      required double yh,
      required double yw,
      required double h,
      required double vMax,
      required double vMin}) {
    TextPainter valuePainter = TextPainter(
      text: TextSpan(
        text: layer.value.toStringAsFixed(2),
        style: TextStyle(color: layer.textColor, height: 1.05),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.drawRRect(
        RRect.fromLTRBR(
            0,
            ChartLayer.cocaY(
                    layer.value, h, xh, yh, vMax, vMin, originOffset, origin) +
                valuePainter.height / 2,
            yw,
            ChartLayer.cocaY(
                    layer.value, h, xh, yh, vMax, vMin, originOffset, origin) -
                valuePainter.height / 2,
            const Radius.circular(0)),
        Paint()
          ..style = PaintingStyle.fill
          ..color = layer.color);
    valuePainter.paint(
        canvas,
        Offset(
            yw - valuePainter.width - 4, //-4 is random padding const
            ChartLayer.cocaY(
                    layer.value, h, xh, yh, vMax, vMin, originOffset, origin) -
                valuePainter.height / 2));
    canvas.drawLine(
        Offset(
            yw,
            ChartLayer.cocaY(
                layer.value, h, xh, yh, vMax, vMin, originOffset, origin)),
        Offset(
            size.width,
            ChartLayer.cocaY(
                layer.value, h, xh, yh, vMax, vMin, originOffset, origin)),
        Paint()..color = layer.color);
  }
}
