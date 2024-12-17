import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fin_chart/chart_painter.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/trend_line.dart';
import 'package:tradeable_learn_widget/fin_chart/models/fin_candle.dart';
import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/x_axis_settings.dart';
import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/y_axis_settings.dart';
import 'package:tradeable_learn_widget/fin_chart/utils.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/layer.dart';

// const fcbg = Color(0xFF000000);

const candleWidth = 10;

//enum YAxisPos { left, right }

enum ChartFrame { fluid, rigid }

enum ChartType { line, candle }

class ChartOffsets {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomRight;
  final Offset bottomLeft;

  ChartOffsets(
      {required this.topLeft,
      required this.topRight,
      required this.bottomRight,
      required this.bottomLeft});
}

class FinChart extends StatefulWidget {
  final EdgeInsets padding;
  final ChartFrame chartFrame;
  final YAxisSettings yAxisSettings;
  final XAxisSettings xAxisSettings;
  final List<Layer> layers;
  final ChartType chartType;
  final bool allowVerticalZoom;
  final bool allowVerticalDrag;
  final bool allowHorizontalZoom;
  final bool allowHorizontalDrag;
  final List<FinCandle> candleData;

  const FinChart(
      {super.key,
      required this.layers,
      this.padding = const EdgeInsets.all(8),
      // this.axisStyle = const TextStyle(
      //     color: Colors.white, fontSize: 12, fontWeight: FontWeight.w200),
      // this.yAxisPos = YAxisPos.left,
      this.yAxisSettings = const YAxisSettings(),
      this.xAxisSettings = const XAxisSettings(),
      this.chartFrame = ChartFrame.rigid,
      this.allowVerticalZoom = false,
      this.allowVerticalDrag = false,
      this.allowHorizontalDrag = true,
      this.allowHorizontalZoom = true,
      this.chartType = ChartType.line,
      required this.candleData});

  @override
  State<FinChart> createState() => _FinChartState();
}

class _FinChartState extends State<FinChart> {
  double yMin = 0;
  double yMax = 100;
  double xMin = 0;
  double xMax = 20;
  int yFreq = 10;
  int xFreq = 10;
  late ChartOffsets chartOffsets;

  double horizontalScale = 1;
  double previousHorizontalScale = 1.0;
  double xStepUnit = 20;
  double xStepWidth = candleWidth * 2;

  double verticalScale = 1;
  double previousVerticalScale = 1.0;
  double yStepUnit = 0;
  double yStepHeight = 20;

  Offset canvasOriginOffset = Offset.zero;

  bool isCanvasAllowedToScroll = true;
  Layer? selectedLayer;

  List<String> orientedLayers = [];

  List<String> getListOfAxisValues(min, max, freq) {
    List<String> valuesAsStr = [];
    double unitLenght = (max - min) / freq;
    double value = min.toDouble();
    valuesAsStr.add(value.toStringAsFixed(2));
    while (value < max) {
      value += unitLenght;
      valuesAsStr.add(value.toStringAsFixed(2));
    }
    valuesAsStr.add(max.toDouble().toStringAsFixed(2));
    return valuesAsStr;
  }

  getChartOriginOffset(Size canvasSize) {
    Size largetYLabel = getLargetRnderBoxSizeForList(
        getListOfAxisValues(yMin, yMax, yFreq),
        widget.yAxisSettings.axisTextStyle);
    Size largetXLabel = getLargetRnderBoxSizeForList(
        getListOfAxisValues(xMin, xMax, xFreq),
        widget.xAxisSettings.axisTextStyle);
    switch (widget.yAxisSettings.yAxisPos) {
      case YAxisPos.left:
        chartOffsets = ChartOffsets(
            topLeft: Offset(largetYLabel.width, largetYLabel.height / 2),
            topRight: Offset(canvasSize.width - largetXLabel.width / 2,
                largetYLabel.height / 2),
            bottomRight: Offset(canvasSize.width - largetXLabel.width / 2,
                canvasSize.height - largetXLabel.height),
            bottomLeft: Offset(
                largetYLabel.width, canvasSize.height - largetXLabel.height));
        break;
      case YAxisPos.right:
        chartOffsets = ChartOffsets(
            topLeft: Offset(largetXLabel.width / 2, largetYLabel.height / 2),
            topRight: Offset(
                canvasSize.width - largetYLabel.width, largetYLabel.height / 2),
            bottomRight: Offset(canvasSize.width - largetYLabel.width,
                canvasSize.height - largetXLabel.height),
            bottomLeft: Offset(largetXLabel.width / 2,
                canvasSize.height - largetXLabel.height));
        break;
    }
  }

  setXYValues() {
    (double, double) range = findMinMaxWithPercentage(widget.candleData);
    yMin = range.$1;
    yMax = range.$2;
    xMin = 0;
    xMax = widget.candleData.length.toDouble();
  }

  double getXStepSize() {
    switch (widget.chartFrame) {
      case ChartFrame.fluid:
        return candleWidth * 2;
      case ChartFrame.rigid:
        return min(
            candleWidth * 2,
            (chartOffsets.bottomRight.dx - chartOffsets.bottomLeft.dx) /
                (widget.candleData.length + 1));
    }
  }

  double getYStepHeight() {
    return (chartOffsets.bottomLeft.dy - chartOffsets.topLeft.dy) / yFreq;
  }

  double getYStepUnit() {
    return (yMax - yMin) / yFreq;
  }

  onDoubleTap() {
    setState(() {
      horizontalScale = 1;
      previousHorizontalScale = 1;
      xStepWidth = getXStepSize();
      verticalScale = 1;
      previousVerticalScale = 1;
      yStepHeight = getYStepHeight();
      canvasOriginOffset = Offset.zero;
    });
  }

  onTapDown(TapDownDetails details) {
    setState(() {
      Offset offset = convertTouchOffsetToChartOffset(details.localPosition);
      for (Layer layer in widget.layers) {
        String? id = layer.getSelectedId(offset.dx, offset.dy,
            hError: 1, vError: yStepUnit);
        if (id != null) {
          isCanvasAllowedToScroll = false;
          selectedLayer = layer;
          break;
        }
      }
    });
  }

  onScaleStart(ScaleStartDetails details) {
    if (details.pointerCount == 2) {
      if (widget.allowHorizontalZoom) {
        previousHorizontalScale = horizontalScale;
      }
      if (widget.allowHorizontalDrag) {
        previousVerticalScale = verticalScale;
      }
    }
    if (details.pointerCount == 1) {
      onTapDown(TapDownDetails(localPosition: details.localFocalPoint));
    }
  }

  onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      if (details.pointerCount == 1) {
        if (isCanvasAllowedToScroll) {
          canvasOriginOffset = Offset(
              (canvasOriginOffset.dx +
                      (widget.allowHorizontalDrag
                          ? details.focalPointDelta.dx
                          : 0))
                  .clamp(
                      -(xStepWidth / 2 +
                          (widget.candleData.length * xStepWidth)),
                      0),
              canvasOriginOffset.dy -
                  (widget.allowVerticalDrag ? details.focalPointDelta.dy : 0));
        } else {
          Offset offset =
              convertTouchOffsetToChartOffset(details.localFocalPoint);
          selectedLayer?.onChange(offset.dx, offset.dy,
              hError: xStepWidth, vError: yStepUnit);

          if (selectedLayer != null && selectedLayer is TrendLine) {
            Offset offset = convertTouchOffsetToChartOffset(Offset(
                details.localFocalPoint.dx + xStepWidth,
                details.localFocalPoint.dy));

            if (details.localFocalPoint.dx >
                (chartOffsets.bottomRight.dx - xStepWidth)) {
              canvasOriginOffset =
                  Offset((canvasOriginOffset.dx - 4), canvasOriginOffset.dy);
            }

            if (details.localFocalPoint.dx <
                (chartOffsets.bottomLeft.dx + xStepWidth)) {
              canvasOriginOffset =
                  Offset((canvasOriginOffset.dx + 4), canvasOriginOffset.dy);
            }

            selectedLayer?.onChange(offset.dx, offset.dy,
                hError: 1, vError: yStepUnit);
          }
        }
      }
      if (details.pointerCount == 2) {
        if (widget.allowHorizontalZoom) {
          horizontalScale = previousHorizontalScale * details.scale;
        }
        if (widget.allowVerticalZoom) {
          verticalScale = previousVerticalScale * details.scale;
        }
      }
    });
  }

  onScaleEnd(ScaleEndDetails details) {
    setState(() {
      isCanvasAllowedToScroll = true;
    });
  }

  Offset convertTouchOffsetToChartOffset(Offset offset) {
    return Offset(
        (offset.dx -
                (chartOffsets.bottomLeft.dx +
                    canvasOriginOffset.dx +
                    xStepWidth / 2)) /
            xStepWidth,
        ((chartOffsets.bottomLeft.dy - canvasOriginOffset.dy - offset.dy) *
                yStepUnit /
                yStepHeight) +
            yMin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      // color: fcbg,
      child: LayoutBuilder(builder: (context, constraints) {
        setXYValues();
        getChartOriginOffset(Size(constraints.maxWidth, constraints.maxHeight));
        xStepWidth = getXStepSize() * horizontalScale;
        yStepHeight = getYStepHeight() * verticalScale;
        yStepUnit = getYStepUnit();
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: GestureDetector(
            onDoubleTap: onDoubleTap,
            onScaleStart: onScaleStart,
            onScaleUpdate: onScaleUpdate,
            onTapDown: onTapDown,
            onScaleEnd: onScaleEnd,
            child: CustomPaint(
              painter: ChartPainter(
                  yAxisSettings: widget.yAxisSettings,
                  xAxisSettings: widget.xAxisSettings,
                  chartOffsets: chartOffsets,
                  xMin: xMin,
                  yMin: yMin,
                  xStepWidth: xStepWidth,
                  yStepHeight: yStepHeight,
                  yStepUnit: yStepUnit,
                  canvasOriginOffset: canvasOriginOffset,
                  layers: widget.layers,
                  data: widget.candleData,
                  chartType: widget.chartType),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            ),
          ),
        );
      }),
    );
  }
}
