import 'dart:ui';

import 'package:flutter/material.dart';

import '../chart_layer.dart';

class RangeLayer extends ChartLayer {
  final double value1;
  final double value2;
  final Color color;

  RangeLayer({required this.value1, required this.value2, required this.color});

  static draw(
      {required Canvas canvas,
      required Size size,
      required RangeLayer layer,
      required Offset origin,
      required Offset originOffset,
      required double xh,
      required double yh,
      required double yw,
      required double h,
      required double vMax,
      required double vMin}) {
    canvas.drawRRect(
        RRect.fromLTRBR(
            yw,
            ChartLayer.cocaY(
                layer.value1, h, xh, yh, vMax, vMin, originOffset, origin),
            size.width,
            ChartLayer.cocaY(
                layer.value2, h, xh, yh, vMax, vMin, originOffset, origin),
            Radius.zero),
        Paint()
          ..style = PaintingStyle.fill
          ..color = layer.color);
  }
}
