import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fin_chart/fin_chart.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/chart_pointer.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/horizontal_line.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/horizontal_line_hit_box.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/layer.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/point_label.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/trend_line.dart';
import 'package:tradeable_learn_widget/fin_chart/models/fin_candle.dart';
import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/x_axis_settings.dart';
import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/y_axis_settings.dart';
import 'package:tradeable_learn_widget/fin_chart/utils.dart';

class ChartPainter extends CustomPainter {
  final YAxisSettings yAxisSettings;
  final XAxisSettings xAxisSettings;
  final ChartOffsets chartOffsets;
  final double xMin;
  final double yMin;
  final double xStepWidth;
  final double yStepHeight;
  final double yStepUnit;
  final Offset canvasOriginOffset;
  final List<Layer> layers;
  final ChartType chartType;
  final List<FinCandle> data;

  ChartPainter(
      {super.repaint,
      required this.yAxisSettings,
      required this.xAxisSettings,
      required this.chartOffsets,
      required this.xMin,
      required this.yMin,
      required this.xStepWidth,
      required this.yStepHeight,
      required this.yStepUnit,
      required this.canvasOriginOffset,
      required this.layers,
      required this.data,
      required this.chartType});

  @override
  void paint(Canvas canvas, Size size) {
    final outerBoundries = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
        outerBoundries,
        Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 1
          ..color = Colors.transparent);
    canvas.clipRect(outerBoundries);

    switch (yAxisSettings.yAxisPos) {
      case YAxisPos.left:
        canvas.drawLine(
            chartOffsets.bottomLeft,
            chartOffsets.topLeft,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = yAxisSettings.strokeWidth
              ..color = yAxisSettings.axisColor);
        canvas.drawLine(
            chartOffsets.bottomLeft,
            chartOffsets.bottomRight,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = xAxisSettings.strokeWidth
              ..color = xAxisSettings.axisColor);
        break;
      case YAxisPos.right:
        canvas.drawLine(
            chartOffsets.bottomRight,
            chartOffsets.topRight,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = yAxisSettings.strokeWidth
              ..color = yAxisSettings.axisColor);
        canvas.drawLine(
            chartOffsets.bottomLeft,
            chartOffsets.bottomRight,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = xAxisSettings.strokeWidth
              ..color = xAxisSettings.axisColor);
        break;
    }

    drawYAxisLabels(canvas);
    drawXAxisLabels(canvas);

    for (Layer layer in layers) {
      if (layer is HorizontalLine) {
        plotHorizontalLineLabel(canvas, size, layer);
      }
    }

    final innerBoundries = Rect.fromLTWH(
        chartOffsets.bottomLeft.dx,
        chartOffsets.topLeft.dy,
        chartOffsets.bottomRight.dx - chartOffsets.bottomLeft.dx,
        chartOffsets.bottomRight.dy - chartOffsets.topRight.dy);
    canvas.drawRect(
        innerBoundries,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0
          ..color = Colors.transparent);

    canvas.clipRect(innerBoundries);

    switch (chartType) {
      case ChartType.line:
        for (int i = 0; i < data.length - 1; i++) {
          plotLine(canvas, Offset(i.toDouble(), data[i].close),
              Offset(i + 1, data[i + 1].close));
        }
        break;
      case ChartType.candle:
        for (FinCandle candle in data) {
          plotCandle(canvas, candle.candleId.toDouble(), candle);
        }
        break;
    }

    for (Layer layer in layers) {
      if (layer is ChartPointer) {
        plotPoint(canvas, layer.pos, layer.value);
      }
      if (layer is HorizontalLine) {
        plotHorizontalLine(canvas, layer);
      }

      if (layer is HorizontalLineHitBox) {
        plotHorizontalLineHitBox(canvas, layer);
      }

      if (layer is TrendLine) {
        plotTrendLine(canvas, layer);
      }

      if (layer is PointLabel) {
        plotPointLabel(canvas, layer);
      }
    }
  }

  plotPointLabel(Canvas canvas, PointLabel pointLabel) {
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: pointLabel.text,
        style: pointLabel.style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    Offset offset = getOffsetFrom(pointLabel.containerCenterPosition.dx,
        pointLabel.containerCenterPosition.dy);

    canvas.drawRect(
        Rect.fromLTWH(
            offset.dx - text.width / 2 - 10,
            offset.dy - text.height / 2 - 10,
            text.width + 20,
            text.height + 20),
        Paint()
          ..style = PaintingStyle.fill
          ..color = pointLabel.containerColor);
    text.paint(canvas,
        Offset(offset.dx - text.width / 2, offset.dy - text.height / 2));
  }

  plotPoint(Canvas canvas, double pos, double value) {
    canvas.drawCircle(
        getOffsetFrom(pos, value),
        4,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.yellow);
  }

  plotPointFromOffset(Canvas canvas, Offset offset) {
    canvas.drawCircle(
        getOffsetFrom(offset.dx, offset.dy),
        10,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.yellow);
  }

  plotHorizontalLine(Canvas canvas, HorizontalLine line) {
    canvas.drawLine(
        Offset(chartOffsets.bottomLeft.dx, getOffsetFrom(0, line.value).dy),
        Offset(chartOffsets.bottomRight.dx, getOffsetFrom(0, line.value).dy),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = line.lineWidth
          ..color = line.color);
  }

  plotHorizontalLineLabel(Canvas canvas, Size size, HorizontalLine line) {
    Offset offset;
    switch (yAxisSettings.yAxisPos) {
      case YAxisPos.left:
        offset = Offset(
            chartOffsets.bottomLeft.dx,
            getOffsetFrom(0, line.value)
                .dy
                .clamp(chartOffsets.topLeft.dy, chartOffsets.bottomLeft.dy));
        break;
      case YAxisPos.right:
        offset = Offset(
            chartOffsets.bottomRight.dx,
            getOffsetFrom(0, line.value)
                .dy
                .clamp(chartOffsets.topLeft.dy, chartOffsets.bottomLeft.dy));
        break;
    }
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: line.value.toDouble().toStringAsFixed(2),
        style: line.style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    Offset textTopLeftOffset = Offset.zero;
    switch (yAxisSettings.yAxisPos) {
      case YAxisPos.left:
        textTopLeftOffset = Offset(
            offset.dx - text.width - fontPadding, offset.dy - text.height / 2);
        break;
      case YAxisPos.right:
        textTopLeftOffset =
            Offset(offset.dx + fontPadding, offset.dy - text.height / 2);
        break;
    }
    switch (yAxisSettings.yAxisPos) {
      case YAxisPos.left:
        canvas.drawRect(
            Rect.fromLTRB(0, textTopLeftOffset.dy, chartOffsets.bottomLeft.dx,
                textTopLeftOffset.dy + text.height),
            Paint()
              ..color = line.color
              ..style = PaintingStyle.fill);
        break;
      case YAxisPos.right:
        canvas.drawRect(
            Rect.fromLTRB(chartOffsets.bottomRight.dx, textTopLeftOffset.dy,
                size.width, textTopLeftOffset.dy + text.height),
            Paint()
              ..color = line.color
              ..style = PaintingStyle.fill);
        break;
    }
    text.paint(canvas, textTopLeftOffset);
  }

  plotHorizontalLineHitBox(Canvas canvas, HorizontalLineHitBox hitBox) {
    canvas.drawRect(
        Rect.fromLTRB(
            chartOffsets.bottomLeft.dx,
            getOffsetFrom(0, hitBox.yMax).dy,
            chartOffsets.bottomRight.dx,
            getOffsetFrom(0, hitBox.yMin).dy),
        Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 1
          ..color = hitBox.color);
  }

  plotTrendLine(Canvas canvas, TrendLine trendLine) {
    canvas.drawLine(
        getOffsetFrom(trendLine.startOffset.dx, trendLine.startOffset.dy),
        getOffsetFrom(trendLine.endOffset.dx, trendLine.endOffset.dy),
        Paint()
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..strokeWidth = trendLine.width
          ..color = trendLine.color);
  }

  plotCandle(Canvas canvas, double pos, FinCandle candle) {
    Color candleColor;
    if (candle.isSelected) {
      candleColor = Colors.orange;
    } else if (candle.selectedByModel) {
      candleColor = Colors.purple;
    } else if (candle.open < candle.close) {
      candleColor = Colors.green;
    } else {
      candleColor = Colors.red;
    }

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = candleColor;

    canvas.drawLine(
        getOffsetFrom(pos, candle.high), getOffsetFrom(pos, candle.low), paint);
    canvas.drawRect(
        Rect.fromLTRB(
            getOffsetFrom(pos, candle.open).dx - xStepWidth / 4,
            getOffsetFrom(pos, candle.open).dy,
            getOffsetFrom(pos, candle.open).dx + xStepWidth / 4,
            getOffsetFrom(pos, candle.close).dy),
        paint);
  }

  plotLine(Canvas canvas, Offset start, Offset end) {
    canvas.drawLine(
        getOffsetFrom(start.dx, start.dy),
        getOffsetFrom(end.dx, end.dy),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = Colors.black);
    plotPoint(canvas, start.dx, start.dy);
    plotPoint(canvas, start.dx, start.dy);
  }

  floodBottom(Canvas canvas, Offset offset, double current) {
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: current.toDouble().toStringAsFixed(2),
        style: yAxisSettings.axisTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    Offset textTopLeftOffset = Offset.zero;
    switch (yAxisSettings.yAxisPos) {
      case YAxisPos.left:
        textTopLeftOffset = Offset(
            offset.dx - text.width - fontPadding, offset.dy - text.height / 2);
        break;
      case YAxisPos.right:
        textTopLeftOffset =
            Offset(offset.dx + fontPadding, offset.dy - text.height / 2);
        break;
    }

    if (offset.dy < chartOffsets.bottomLeft.dy) {
      if (offset.dy < chartOffsets.bottomLeft.dy &&
          offset.dy > chartOffsets.topLeft.dy) {
        canvas.drawCircle(
            offset,
            1,
            Paint()
              ..style = PaintingStyle.fill
              ..color = yAxisSettings.axisColor);
        text.paint(canvas, textTopLeftOffset);
      }
      current -= yStepUnit;
      floodBottom(canvas, Offset(offset.dx, offset.dy + yStepHeight), current);
    }
  }

  floodTop(Canvas canvas, Offset offset, double current) {
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: current.toDouble().toStringAsFixed(2),
        style: yAxisSettings.axisTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    Offset textTopLeftOffset = Offset.zero;
    switch (yAxisSettings.yAxisPos) {
      case YAxisPos.left:
        textTopLeftOffset = Offset(
            offset.dx - text.width - fontPadding, offset.dy - text.height / 2);
        break;
      case YAxisPos.right:
        textTopLeftOffset =
            Offset(offset.dx + fontPadding, offset.dy - text.height / 2);
        break;
    }

    if (offset.dy > chartOffsets.topLeft.dy) {
      if (offset.dy < chartOffsets.bottomLeft.dy &&
          offset.dy > chartOffsets.topLeft.dy) {
        canvas.drawCircle(
            offset,
            1,
            Paint()
              ..style = PaintingStyle.fill
              ..color = yAxisSettings.axisColor);
        text.paint(canvas, textTopLeftOffset);
      }
      current += yStepUnit;
      floodTop(canvas, Offset(offset.dx, offset.dy - yStepHeight), current);
    }
  }

  drawYAxisLabels(Canvas canvas) {
    Offset startOffset;
    switch (yAxisSettings.yAxisPos) {
      case YAxisPos.left:
        startOffset = Offset(chartOffsets.bottomLeft.dx,
            chartOffsets.bottomLeft.dy - canvasOriginOffset.dy);
        break;
      case YAxisPos.right:
        startOffset = Offset(chartOffsets.bottomRight.dx,
            chartOffsets.bottomRight.dy - canvasOriginOffset.dy);
        break;
    }

    floodTop(canvas, startOffset, yMin);
    floodBottom(canvas, startOffset, yMin);
  }

  floodLeft(Canvas canvas, Offset offset, double current) {
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: current.toStringAsFixed(0),
        style: xAxisSettings.axisTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    Offset textTopLeftOffset =
        Offset(offset.dx - text.width / 2, offset.dy + fontPadding);

    if (offset.dx > chartOffsets.bottomLeft.dx) {
      if (offset.dx > chartOffsets.bottomLeft.dx &&
          offset.dx < chartOffsets.bottomRight.dx) {
        canvas.drawCircle(
            offset,
            1,
            Paint()
              ..style = PaintingStyle.fill
              ..color = xAxisSettings.axisColor);
        text.paint(canvas, textTopLeftOffset);
      }
      current -= 1.0;
      floodLeft(canvas, Offset(offset.dx - xStepWidth, offset.dy), current);
    }
  }

  floodRight(Canvas canvas, Offset offset, double current) {
    final TextPainter text = TextPainter(
      text: TextSpan(
        text: current.toStringAsFixed(0),
        style: xAxisSettings.axisTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    Offset textTopLeftOffset =
        Offset(offset.dx - text.width / 2, offset.dy + fontPadding);

    if (offset.dx < chartOffsets.bottomRight.dx) {
      if (offset.dx > chartOffsets.bottomLeft.dx &&
          offset.dx < chartOffsets.bottomRight.dx) {
        canvas.drawCircle(
            offset,
            1,
            Paint()
              ..style = PaintingStyle.fill
              ..color = xAxisSettings.axisColor);
        text.paint(canvas, textTopLeftOffset);
      }
      current += 1.0;
      floodRight(canvas, Offset(offset.dx + xStepWidth, offset.dy), current);
    }
  }

  drawXAxisLabels(Canvas canvas) {
    Offset startOffset = Offset(
        chartOffsets.bottomLeft.dx + canvasOriginOffset.dx + xStepWidth / 2,
        chartOffsets.bottomLeft.dy);
    floodLeft(canvas, startOffset, xMin);
    floodRight(canvas, startOffset, xMin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Offset getOffsetFrom(double x, double y) {
    return Offset(
        chartOffsets.bottomLeft.dx +
            canvasOriginOffset.dx +
            xStepWidth / 2 +
            (x * xStepWidth),
        chartOffsets.bottomLeft.dy -
            canvasOriginOffset.dy -
            ((y - yMin) * yStepHeight / yStepUnit));
  }
}
