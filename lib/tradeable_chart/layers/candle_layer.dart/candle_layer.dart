import 'package:flutter/material.dart';

import '../chart_layer.dart';
import 'candle.dart';
import 'candle_setting.dart';

class CandleLayer extends ChartLayer {
  final ChartCandleSettings settings;
  final List<Candle> candles;
  final bool areCandlesPreSelected;
  final Function(Candle)? onCandleSelect;

  CandleLayer(
      {required this.settings,
      required this.candles,
      this.onCandleSelect,
      this.areCandlesPreSelected = false});

  static draw(
      {required Canvas canvas,
      required Size size,
      required CandleLayer layer,
      required Offset origin,
      required Offset originOffset,
      required double xh,
      required double yh,
      required double yw,
      required double h,
      required double vMax,
      required double vMin}) {
    for (Candle candle in layer.candles) {
      Color candleColor;
      Color shadowColor = layer.settings.shadowColor;
      if (candle.selectedByModel) {
        candleColor = Colors.purple;
      } else if (candle.isSelected) {
        if (layer.areCandlesPreSelected) {
          shadowColor = shadowColor.withOpacity(0.5);
          candleColor = Colors.blue.withOpacity(0.5);
        } else {
          candleColor = Colors.blue;
        }
      } else {
        if (candle.open > candle.close) {
          candleColor = Colors.red;
        } else {
          candleColor = Colors.green;
        }
      }

      //candle shadow
      canvas.drawRRect(
          RRect.fromLTRBR(
              ChartLayer.cocaX(
                  ((layer.settings.bodyThickness * 2) * candle.candleId) -
                      (layer.settings.shadowThickness / 2),
                  yw,
                  originOffset),
              ChartLayer.cocaY(
                  candle.high, h, xh, yh, vMax, vMin, originOffset, origin),
              ChartLayer.cocaX(
                  ((layer.settings.bodyThickness * 2) * candle.candleId) +
                      (layer.settings.shadowThickness / 2),
                  yw,
                  originOffset),
              ChartLayer.cocaY(
                  candle.low, h, xh, yh, vMax, vMin, originOffset, origin),
              Radius.circular(layer.settings.radius)),
          Paint()
            ..style = PaintingStyle.fill
            ..color = shadowColor);

      //candle body border
      canvas.drawRRect(
          RRect.fromLTRBR(
              ChartLayer.cocaX(
                  ((layer.settings.bodyThickness * 2) * candle.candleId) -
                      (layer.settings.bodyThickness / 2),
                  yw,
                  originOffset),
              ChartLayer.cocaY(
                  candle.open, h, xh, yh, vMax, vMin, originOffset, origin),
              ChartLayer.cocaX(
                  ((layer.settings.bodyThickness * 2) * candle.candleId) +
                      (layer.settings.bodyThickness / 2),
                  yw,
                  originOffset),
              ChartLayer.cocaY(
                  candle.close, h, xh, yh, vMax, vMin, originOffset, origin),
              Radius.circular(layer.settings.radius)),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = shadowColor);

      //candle body
      canvas.drawRRect(
          RRect.fromLTRBR(
              ChartLayer.cocaX(
                  ((layer.settings.bodyThickness * 2) * candle.candleId) -
                      (layer.settings.bodyThickness / 2),
                  yw,
                  originOffset),
              ChartLayer.cocaY(
                  candle.open, h, xh, yh, vMax, vMin, originOffset, origin),
              ChartLayer.cocaX(
                  ((layer.settings.bodyThickness * 2) * candle.candleId) +
                      (layer.settings.bodyThickness / 2),
                  yw,
                  originOffset),
              ChartLayer.cocaY(
                  candle.close, h, xh, yh, vMax, vMin, originOffset, origin),
              Radius.circular(layer.settings.radius)),
          Paint()
            ..style = PaintingStyle.fill
            ..color = candleColor);
    }
  }
}
