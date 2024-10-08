import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/vertical_line_layer/vertical_line_layer.dart';

import 'layers/axis_layer/axis_layer.dart';
import 'layers/candle_layer.dart/candle_layer.dart';
import 'layers/chart_layer.dart';
import 'layers/line_layer/line_layer.dart';
import 'layers/range_layer/range_layer.dart';
import 'layers/rr_layer/rr_layer.dart';

class CustomChartPainter extends CustomPainter {
  final List<ChartLayer> layers;
  final Offset origin;
  final Offset originOffset;
  final double graphHeight;
  final double xh, yh, yw, h, vMax, vMin;

  CustomChartPainter(
      {required this.origin,
      required this.originOffset,
      required this.xh,
      required this.yh,
      required this.yw,
      required this.h,
      required this.vMax,
      required this.vMin,
      required this.layers,
      required this.graphHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.transparent);
    canvas.clipRect(rect);
    canvas.save();

    for (ChartLayer layer in layers) {
      if (layer is AxisLayer) {
        AxisLayer.draw(
            canvas: canvas,
            size: size,
            settings: layer.settings,
            origin: origin,
            originOffset: originOffset,
            xh: xh,
            yh: yh,
            yw: yw,
            h: h,
            vMax: vMax,
            vMin: vMin);
      } else if (layer is CandleLayer) {
        CandleLayer.draw(
            canvas: canvas,
            size: size,
            layer: layer,
            origin: origin,
            originOffset: originOffset,
            xh: xh,
            yh: yh,
            yw: yw,
            h: h,
            vMax: vMax,
            vMin: vMin);
      } else if (layer is LineLayer) {
        LineLayer.draw(
            canvas: canvas,
            size: size,
            layer: layer,
            origin: origin,
            originOffset: originOffset,
            xh: xh,
            yh: yh,
            yw: yw,
            h: h,
            vMax: vMax,
            vMin: vMin);
      } else if (layer is RangeLayer) {
        RangeLayer.draw(
            canvas: canvas,
            size: size,
            layer: layer,
            origin: origin,
            originOffset: originOffset,
            xh: xh,
            yh: yh,
            yw: yw,
            h: h,
            vMax: vMax,
            vMin: vMin);
      } else if (layer is VerticalLineLayer) {
        VerticalLineLayer.draw(
            canvas: canvas,
            size: size,
            layer: layer,
            origin: origin,
            originOffset: originOffset,
            xh: xh,
            yh: yh,
            yw: yw,
            h: h,
            vMax: vMax,
            vMin: vMin);
      } else if (layer is RRLayer) {
        RRLayer.draw(
            canvas: canvas,
            size: size,
            layer: layer,
            origin: origin,
            originOffset: originOffset,
            xh: xh,
            yh: yh,
            yw: yw,
            h: h,
            vMax: vMax,
            vMin: vMin);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CustomChartPainter oldDelegate) => false;
}
