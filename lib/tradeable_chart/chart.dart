import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/rr_layer/rr_layer.dart';

import 'custom_chart_painter.dart';
import 'layers/candle_layer.dart/candle.dart';
import 'layers/candle_layer.dart/candle_layer.dart';
import 'layers/chart_layer.dart';
import 'layers/line_layer/line_layer.dart';

class Chart extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final List<ChartLayer> layers;
  final double yMax;
  final double yMin;

  const Chart({
    super.key,
    required this.layers,
    required this.yMax,
    required this.yMin,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> with SingleTickerProviderStateMixin {
  late TextPainter yAxisValuePainter;
  late TextPainter xAxisValuePainter;
  late double graphHeight;
  late Offset origin;
  Offset originOffset = Offset.zero;
  late double xh, yh, yw, h, vMax, vMin;
  ChartLayer? selectedLayer;
  bool isNewDataAdded = true;
  CandleLayer? originalCandleLayer;
  late double defaultCandleBodyThickness;

  @override
  void initState() {
    if (getCandleLayerFromLayers() != null) {
      CandleLayer candleLayer = getCandleLayerFromLayers()!;
      defaultCandleBodyThickness = candleLayer.settings.bodyThickness;
      List<Candle> candles = [];
      candles.addAll(candleLayer.candles);
      originalCandleLayer =
          CandleLayer(settings: candleLayer.settings, candles: candles);
    }
    super.initState();
  }

  void onTapUp(TapUpDetails details) {
    for (ChartLayer layer in widget.layers) {
      if (layer is CandleLayer) {
        for (Candle candle in layer.candles) {
          double candleMax =
              ((layer.settings.bodyThickness * 2) * candle.candleId) +
                  (layer.settings.bodyThickness / 2);
          double candleMin =
              ((layer.settings.bodyThickness * 2) * candle.candleId) -
                  (layer.settings.bodyThickness / 2);
          if (candle.high >
                  ChartLayer.cacoY(details.localPosition.dy, xh, yh, yw, h,
                      vMax, vMin, originOffset) &&
              candle.low <
                  ChartLayer.cacoY(details.localPosition.dy, xh, yh, yw, h,
                      vMax, vMin, originOffset) &&
              candleMax >
                  ChartLayer.cacoX(
                      details.localPosition.dx, yw, originOffset) &&
              candleMin <
                  ChartLayer.cacoX(
                      details.localPosition.dx, yw, originOffset)) {
            if (layer.onCandleSelect != null) {
              layer.onCandleSelect!(candle);
            }
          }
        }
      }
    }
  }

  void onPanDown(DragDownDetails details) {
    double errorMargin = 20;
    bool isLayerLocked = false;
    for (ChartLayer layer in widget.layers) {
      if (layer is LineLayer && !isLayerLocked) {
        if (ChartLayer.cocaY(layer.value, h, xh, yh, vMax, vMin, originOffset,
                        origin) -
                    errorMargin <=
                details.localPosition.dy &&
            ChartLayer.cocaY(layer.value, h, xh, yh, vMax, vMin, originOffset,
                        origin) +
                    errorMargin >=
                details.localPosition.dy) {
          isLayerLocked = true;
          selectedLayer = layer;
        }
      } else if (layer is RRLayer && !isLayerLocked) {
        if (ChartLayer.cocaY(layer.target, h, xh, yh, vMax, vMin, originOffset, origin) - errorMargin <= details.localPosition.dy &&
            ChartLayer.cocaY(layer.target, h, xh, yh, vMax, vMin, originOffset, origin) + errorMargin >=
                details.localPosition.dy &&
            ChartLayer.cocaX(layer.startAt, yw, originOffset) <=
                details.localPosition.dx &&
            ChartLayer.cocaX(layer.endAt, yw, originOffset) >=
                details.localPosition.dx) {
          isLayerLocked = true;
          layer.updatingValue = "target";
          selectedLayer = layer;
        } else if (ChartLayer.cocaY(layer.stoploss, h, xh, yh, vMax, vMin, originOffset, origin) - errorMargin <= details.localPosition.dy &&
            ChartLayer.cocaY(layer.stoploss, h, xh, yh, vMax, vMin, originOffset, origin) + errorMargin >=
                details.localPosition.dy &&
            ChartLayer.cocaX(layer.startAt, yw, originOffset) <=
                details.localPosition.dx &&
            ChartLayer.cocaX(layer.endAt, yw, originOffset) >=
                details.localPosition.dx) {
          isLayerLocked = true;
          layer.updatingValue = "stoploss";
          selectedLayer = layer;
        } else if (ChartLayer.cocaX(layer.startAt, yw, originOffset) - errorMargin <=
                details.localPosition.dx &&
            ChartLayer.cocaX(layer.startAt, yw, originOffset) + errorMargin >=
                details.localPosition.dx) {
          isLayerLocked = true;
          layer.updatingValue = "startAt";
          selectedLayer = layer;
        } else if (ChartLayer.cocaX(layer.endAt, yw, originOffset) - errorMargin <=
                details.localPosition.dx &&
            ChartLayer.cocaX(layer.endAt, yw, originOffset) + errorMargin >=
                details.localPosition.dx) {
          isLayerLocked = true;
          layer.updatingValue = "endAt";
          selectedLayer = layer;
        } else if (ChartLayer.cocaY(layer.value, h, xh, yh, vMax, vMin, originOffset, origin) - errorMargin <=
                details.localPosition.dy &&
            ChartLayer.cocaY(layer.value, h, xh, yh, vMax, vMin, originOffset, origin) + errorMargin >=
                details.localPosition.dy &&
            ChartLayer.cocaX(layer.startAt, yw, originOffset) <= details.localPosition.dx &&
            ChartLayer.cocaX(layer.endAt, yw, originOffset) >= details.localPosition.dx) {
          isLayerLocked = true;
          layer.updatingValue = "value";
          selectedLayer = layer;
        }
      }
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    for (ChartLayer layer in widget.layers) {
      if (layer is LineLayer &&
          selectedLayer != null &&
          selectedLayer is LineLayer) {
        if ((selectedLayer as LineLayer).id == layer.id) {
          if (layer.onUpdate != null) {
            layer.onUpdate!(layer.value = layer.value +
                (-details.delta.dy / graphHeight) * (vMax - vMin));
          }
        }
      } else if (layer is RRLayer &&
          selectedLayer != null &&
          selectedLayer is RRLayer) {
        if (layer.onUpdate != null) {
          if ((selectedLayer as RRLayer).updatingValue == "value") {
            layer.onUpdate!(
                layer.value + (-details.delta.dy / graphHeight) * (vMax - vMin),
                layer.target +
                    (-details.delta.dy / graphHeight) * (vMax - vMin),
                layer.stoploss +
                    (-details.delta.dy / graphHeight) * (vMax - vMin),
                layer.startAt + details.delta.dx,
                layer.endAt + details.delta.dx);
          } else if ((selectedLayer as RRLayer).updatingValue == "target") {
            layer.onUpdate!(
                layer.value,
                layer.target +
                    (-details.delta.dy / graphHeight) * (vMax - vMin),
                layer.stoploss,
                layer.startAt,
                layer.endAt);
          } else if ((selectedLayer as RRLayer).updatingValue == "stoploss") {
            layer.onUpdate!(
                layer.value,
                layer.target,
                layer.stoploss +
                    (-details.delta.dy / graphHeight) * (vMax - vMin),
                layer.startAt,
                layer.endAt);
          } else if ((selectedLayer as RRLayer).updatingValue == "startAt") {
            layer.onUpdate!(layer.value, layer.target, layer.stoploss,
                layer.startAt + details.delta.dx, layer.endAt);
          } else if ((selectedLayer as RRLayer).updatingValue == "endAt") {
            layer.onUpdate!(layer.value, layer.target, layer.stoploss,
                layer.startAt, layer.endAt + details.delta.dx);
          }
        }
      }
    }
    if (selectedLayer == null) {
      setState(() {
        originOffset =
            Offset(originOffset.dx + details.delta.dx, originOffset.dy);
        // originOffset = Offset(originOffset.dx + details.delta.dx,
        //     originOffset.dy + details.delta.dy);
      });
    }
  }

  void onPanEnd(DragEndDetails details) {
    selectedLayer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: LayoutBuilder(builder: (context, constraints) {
        _calculate(constraints);
        adjustChartForNewData(constraints);
        return GestureDetector(
          onTapUp: onTapUp,
          onPanDown: onPanDown,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          child: CustomPaint(
            painter: CustomChartPainter(
                origin: origin,
                originOffset: originOffset,
                xh: xh,
                yh: yh,
                yw: yw,
                h: h,
                vMax: vMax,
                vMin: vMin,
                layers: widget.layers,
                graphHeight: graphHeight),
            size: Size(constraints.maxWidth, constraints.maxHeight),
          ),
        );
      }),
    );
  }

  void _calculate(BoxConstraints constraints) {
    yAxisValuePainter = TextPainter(
      text: const TextSpan(
        text: "99999.99",
        style: TextStyle(color: Colors.black, height: 1.05),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    xAxisValuePainter = TextPainter(
      text: const TextSpan(
        text: "12:50\ndd/mm/yyyy",
        style: TextStyle(color: Colors.black, height: 1.05),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    h = constraints.maxHeight;
    yh = yAxisValuePainter.height / 2;
    yw = yAxisValuePainter.width;
    xh = xAxisValuePainter.height;

    vMax = widget.yMax + (widget.yMax - widget.yMin) * 0.5;
    vMin = widget.yMin - (widget.yMax - widget.yMin) * 0.5;

    graphHeight = constraints.maxHeight -
        xAxisValuePainter.height -
        yAxisValuePainter.height / 2;

    origin = Offset(
        yAxisValuePainter.width, graphHeight + yAxisValuePainter.height / 2);

    CandleLayer? candleLayer = getCandleLayerFromLayers();
    if (candleLayer != null && candleLayer.settings.adaptiveBodyThickness) {
      double newThickness =
          (constraints.maxWidth - origin.dx) / (candleLayer.candles.length * 2);

      if (newThickness > defaultCandleBodyThickness) {
        getCandleLayerFromLayers()?.settings.bodyThickness =
            defaultCandleBodyThickness;
      } else {
        getCandleLayerFromLayers()?.settings.bodyThickness = newThickness;
      }
    }
  }

  void adjustChartForNewData(BoxConstraints constraints) {
    if (originalCandleLayer != null &&
        getCandleLayerFromLayers() != null &&
        originalCandleLayer!.candles.length <
            getCandleLayerFromLayers()!.candles.length) {
      if (getCandleLayerFromLayers() != null) {
        CandleLayer candleLayer = getCandleLayerFromLayers()!;
        List<Candle> candles = [];
        candles.addAll(candleLayer.candles);
        originalCandleLayer =
            CandleLayer(settings: candleLayer.settings, candles: candles);
      }
      if (constraints.maxWidth - yAxisValuePainter.width - originOffset.dx <
          originalCandleLayer!.candles.length *
              originalCandleLayer!.settings.bodyThickness *
              2) {
        originOffset = Offset.zero;
        originOffset = Offset(
            originOffset.dx -
                ((originalCandleLayer!.candles.length *
                        originalCandleLayer!.settings.bodyThickness *
                        2) -
                    (constraints.maxWidth - yAxisValuePainter.width)),
            originOffset.dy);
      }
      // if (constraints.maxWidth - yAxisValuePainter.width <
      //     originalCandleLayer!.candles.length *
      //         originalCandleLayer!.settings.bodyThickness *
      //         2) {
      //   originOffset = Offset.zero;
      //   originOffset = Offset(
      //       originOffset.dx -
      //           ((originalCandleLayer!.candles.length *
      //                   originalCandleLayer!.settings.bodyThickness *
      //                   2) -
      //               (constraints.maxWidth - yAxisValuePainter.width)),
      //       originOffset.dy);
      // }
    }
  }

  CandleLayer? getCandleLayerFromLayers() {
    for (ChartLayer layer in widget.layers) {
      if (layer is CandleLayer) {
        return layer;
      }
    }
    return null;
  }
}
