import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/fin_chart/fin_chart.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/point_label.dart';
import 'package:tradeable_learn_widget/fin_chart/layers/trend_line.dart';
import 'package:tradeable_learn_widget/fin_chart/models/fin_candle.dart';
import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/x_axis_settings.dart';
import 'package:tradeable_learn_widget/fin_chart/settings/axis_settings/y_axis_settings.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/trend_line/models/question_generator.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class TrendLineChart extends StatefulWidget {
  final TrendLineModel model;

  const TrendLineChart({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _TrendLineChart();
}

class _TrendLineChart extends State<TrendLineChart>
    with TickerProviderStateMixin {
  late TrendLineModel model;
  late double pos;
  late double value;
  late Offset startOffset;
  late Offset endOffset;
  List<Question> questions = [];
  int currentQuestionIndex = 0;

  bool isAnimating = false;

  @override
  void didUpdateWidget(covariant TrendLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      setState(() {
        model = widget.model;
        isAnimating = false;
      });
      getCandles();
    }
  }

  @override
  void initState() {
    model = widget.model;
    startOffset = Offset(4, model.yMin);
    endOffset = Offset(model.candles.length - 4, model.yMax);
    getCandles();
    initOffsets();
    questions = TrendLineQuestionGenerator.generateQuestions(model);
    super.initState();
  }

  void initOffsets() {
    setState(() {
      if (model.pointLabels.isNotEmpty) {
        for (int i = 0; i < model.pointLabels.length; i++) {
          model.pointLabelResponse.add(UserPointLabelResponse(
              model.pointLabels[i].tag,
              model.candles.length / 2 + i,
              model.yMax,
              Colors.blue));
        }
      }
      if (model.lineOffsets.isNotEmpty) {
        for (int i = 0; i < model.lineOffsets.length; i++) {
          List<UserLineResponse> userLineResponses = [];

          userLineResponses.add(UserLineResponse(
            i.toString(),
            [
              Offset(
                  4,
                  model.yMin +
                      Random().nextDouble() * (model.yMax - model.yMin)),
              Offset(
                  model.candles.length - 4,
                  model.yMax -
                      Random().nextDouble() * (model.yMax - model.yMin)),
            ],
            Colors.blue,
          ));

          model.lineResponse.add(userLineResponses);
        }
      }
    });
  }

  void getCandles() async {
    model.uiCandles.clear();

    for (FinCandle candle in model.candles
        .map((e) => FinCandle(
            candleId: e.candleNum,
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
            volume: e.vol.round()))
        .toList()) {
      await Future.delayed(const Duration(milliseconds: 50));

      if (!model.loadTillEndCandle) {
        if (model.atTime != 0) {
          if (candle.dateTime.millisecondsSinceEpoch > model.atTime) {
            break;
          }
        }
      }

      setState(() {
        model.uiCandles.add(candle);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return model.uiCandles.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 20),
            height: 350,
            child: FinChart(
                yAxisSettings: YAxisSettings(
                    axisTextStyle: textStyles.smallNormal
                        .copyWith(color: colors.axisColor)),
                xAxisSettings: const XAxisSettings(
                    strokeWidth: 1,
                    axisTextStyle: TextStyle(color: Colors.transparent)),
                allowHorizontalZoom: true,
                chartType:
                    model.isLineChart ? ChartType.line : ChartType.candle,
                layers: [
                  ...model.pointLabelResponse.map((e) {
                    return PointLabel(
                        id: e.id,
                        containerColor: e.color,
                        containerCenterPosition: Offset(e.pos, e.value),
                        text: e.id,
                        isFixed: false,
                        onUpdate: (p0) {
                          var elementToUpdate = model.pointLabelResponse
                              .firstWhere((element) => element.id == e.id);
                          elementToUpdate.pos = p0.containerCenterPosition.dx;
                          elementToUpdate.value = p0.containerCenterPosition.dy;
                        });
                  }),
                  ...model.lineResponse.expand((lineData) {
                    return lineData.map((i) {
                      return TrendLine(
                          id: i.id,
                          startOffset: i.offset[0],
                          endOffset: i.offset[1],
                          color: i.color,
                          onUpdate: (p0) {
                            var a = lineData
                                .firstWhere((element) => element.id == i.id);
                            a.offset = [p0.startOffset, p0.endOffset];
                          });
                    });
                  }),
                  ...model.pointLabelCorrectResponse.map((e) {
                    return PointLabel(
                        id: e.id,
                        containerColor: e.color,
                        containerCenterPosition: Offset(e.pos, e.value),
                        text: e.id,
                        isFixed: true);
                  }),
                  ...model.lineCorrectResponse.expand((lineData) {
                    return lineData.map((i) {
                      return TrendLine(
                          id: i.id,
                          startOffset: i.offset[0],
                          endOffset: i.offset[1],
                          color: i.color,
                          width: 6);
                    });
                  }),
                ],
                candleData: model.uiCandles),
          )
        : Container();
  }
}
