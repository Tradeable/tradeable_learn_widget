import 'package:flutter/material.dart';

import '../chart_layer.dart';
import 'axis_setting.dart';

class AxisLayer extends ChartLayer {
  final AxisSettings settings;

  const AxisLayer({
    required this.settings,
  });

  static draw(
      {required Canvas canvas,
      required Size size,
      required AxisSettings settings,
      required Offset origin,
      required Offset originOffset,
      required double xh,
      required double yh,
      required double yw,
      required double h,
      required double vMax,
      required double vMin}) {
    canvas.drawLine(origin, Offset(origin.dx, yh),
        Paint()..color = settings.axisColor); //yAxis

    canvas.drawLine(origin, Offset(size.width, origin.dy),
        Paint()..color = settings.axisColor); //xAxis

    for (int i = 0; i <= settings.yFreq; i++) {
      double atHeight = origin.dy - (i * (h - xh - yh) / settings.yFreq);
      TextPainter valuePainter = TextPainter(
        text: TextSpan(
          text: ChartLayer.cacoY(
                  atHeight, xh, yh, yw, h, vMax, vMin, originOffset)
              .toStringAsFixed(2),
          style: TextStyle(color: settings.yAxistextColor, height: 1.05),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      valuePainter.paint(
          canvas,
          Offset(
              origin.dx - valuePainter.width - 4, //-4 is random padding const
              atHeight - yh));
    }

    TextPainter valuePainter;
    List<Offset> originOffsets = [];
    var ofSets = {};

    if (settings.xAxisValues != null) {
      double xInterval = (size.width - xh - yw) / settings.xAxisValues!.length;

      for (int i = 0; i < settings.xAxisValues!.length; i++) {
        double atWidth = origin.dx + (i * xInterval) + xInterval / 2;

        valuePainter = TextPainter(
          text: TextSpan(
            text: settings.xAxisValues![i],
            style: const TextStyle(
                color: Colors.white, height: 1.05, fontSize: 13),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        valuePainter.paint(
            canvas,
            Offset(ChartLayer.cocaX(atWidth - yw * 1.5, yw, originOffset),
                origin.dy + valuePainter.height));
        originOffsets.add(originOffset);
        ofSets[i] = originOffset;
      }
    }
  }
}
