import 'package:flutter/material.dart';
import '../chart_layer.dart';

class VerticalLineLayer extends ChartLayer {
  final String id;
  double value;
  final Color color;

  VerticalLineLayer({
    required this.id,
    required this.value,
    required this.color,
  });

  static draw(
      {required Canvas canvas,
      required Size size,
      required VerticalLineLayer layer,
      required Offset origin,
      required Offset originOffset,
      required double xh,
      required double yh,
      required double yw,
      required double h,
      required double vMax,
      required double vMin}) {
    canvas.drawLine(
        Offset(
            ChartLayer.cocaX(layer.value, yw, originOffset), originOffset.dy),
        Offset(ChartLayer.cocaX(layer.value, yw, originOffset), origin.dy),
        Paint()..color = layer.color);
  }
}
