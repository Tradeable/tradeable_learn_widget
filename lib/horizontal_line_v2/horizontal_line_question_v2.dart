import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/horizontal_line_v1/horizontal_line_model_v1.dart';
import 'package:tradeable_learn_widget/tradeable_chart/chart.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_setting.dart';
import 'dart:math';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/line_layer/line_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/range_layer/range_layer.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/chart_info_chips.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class HorizontalLineQuestionV2 extends StatefulWidget {
  final HorizontalLineModelV1 model;
  final VoidCallback onNextClick;

  const HorizontalLineQuestionV2(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<HorizontalLineQuestionV2> createState() =>
      _HorizontalLineQuestionState();
}

class _HorizontalLineQuestionState extends State<HorizontalLineQuestionV2>
    with TickerProviderStateMixin {
  late HorizontalLineModelV1 model;
  bool isAnimating = false;
  int currentLineIndex = 0;
  List<bool> processedLines = [];

  @override
  void initState() {
    model = widget.model;
    processedLines =
        List.generate(model.responseRange.length, (index) => false);
    initChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          renderQuestion(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: model.responseRange.map((response) {
              IconData iconData = response.isCorrect == null
                  ? Icons.play_circle
                  : (response.isCorrect! ? Icons.check_circle : Icons.error);

              return Column(
                children: [
                  Icon(iconData,
                      size: 24,
                      color: response.isCorrect == null
                          ? colors.borderColorPrimary
                          : (response.isCorrect!
                              ? colors.bullishColor
                              : colors.bearishColor)),
                  Text(response.title, style: const TextStyle(fontSize: 16)),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          SizedBox(height: constraints.maxHeight * 0.5, child: renderChart()),
          SizedBox(
              height: constraints.maxHeight * 0.2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        model.candles.isNotEmpty
                            ? ChartInfoChips(
                                ticker: model.ticker,
                                timeFrame: model.timeframe,
                                date: DateFormat("dd MMM yyyy").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        model.candles.first.time)))
                            : Container(),
                      ]),
                ],
              )),
          renderActionButton(),
        ],
      );
    });
  }

  Widget renderChart() {
    final colors = Theme.of(context).customColors;

    return Chart(layers: [
      AxisLayer(
          settings: AxisSettings(
              axisColor: colors.axisColor,
              yAxistextColor: colors.axisColor,
              yFreq: 10)),
      if (currentLineIndex < model.userResponse.length)
        LineLayer(
          id: model.userResponse[currentLineIndex].id,
          value: model.userResponse[currentLineIndex].value,
          color: const Color(0xffF9B0CC),
          textColor: colors.axisColor,
          onUpdate: (p0) {
            setState(() {
              model.userResponse[currentLineIndex].value = p0;
            });
          },
          lineColor: colors.borderColorPrimary,
        ),
      CandleLayer(
          settings: ChartCandleSettings(
              bodyThickness: 8,
              adaptiveBodyThickness: true,
              shadowColor: colors.axisColor),
          candles: model.uiCandles),
      ...model.responseRange
          .asMap()
          .entries
          .where((entry) => processedLines[entry.key])
          .map((entry) {
        final response = entry.value;
        return RangeLayer(
            value1: max(response.max, response.min),
            value2: min(response.max, response.min),
            color: const Color.fromARGB(100, 50, 100, 29));
      }),
    ], yMax: model.yMax, yMin: model.yMin);
  }

  Widget renderQuestion() {
    final textStyles = Theme.of(context).customTextStyles;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(model.question, style: textStyles.mediumNormal),
    );
  }

  Widget renderActionButton() {
    final colors = Theme.of(context).customColors;
    final isLastLine = currentLineIndex == model.responseRange.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      child: ButtonWidget(
          color: colors.primary,
          btnContent: isLastLine ? "Next" : "Submit",
          onTap: () {
            if (isLastLine) {
              showFinalResult();
            } else {
              processCurrentLineAndMoveNext();
            }
          }),
    );
  }

  void processCurrentLineAndMoveNext() {
    final currentResponse = model.responseRange[currentLineIndex];
    final currentUserResponse = model.userResponse[currentLineIndex];

    bool isCorrect = min(currentResponse.min, currentResponse.max) <=
            currentUserResponse.value &&
        max(currentResponse.min, currentResponse.max) >=
            currentUserResponse.value;

    setState(() {
      currentResponse.isCorrect = isCorrect;
      processedLines[currentLineIndex] = true;
      currentLineIndex++;
    });

    if (!widget.model.type.contains("STATIC")) {
      _loadCandlesTillEnd();
    }

    animateLine();
  }

  void showFinalResult() {
    int correctCount = model.responseRange
        .where((response) => response.isCorrect == true)
        .length;
    model.isCorrect = correctCount == model.responseRange.length;

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => BottomSheetWidget(
            isCorrect: model.isCorrect,
            model: model.explanationV1,
            onNextClick: () {
              widget.onNextClick();
            }));
  }

  void initChartData() {
    for (int i = 0; i < model.responseRange.length; i++) {
      model.userResponse.add(HorizontalLineV1UserResponse(
          i.toString(), model.yMax + i * 2 - (model.yMax - model.yMin) / 2));
    }
    if (widget.model.type == "HorizontalLine_STATIC" ||
        widget.model.type == "MultipleHorizontalLine_STATIC") {
      _loadAllCandles();
    } else {
      _loadCandlesTillAt();
    }
    animateLine();
  }

  void animateLine() {
    if (!isAnimating) {
      final value = model.userResponse[currentLineIndex].value;
      final endValue = value + 15;

      final controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );

      final animation = Tween<double>(
        begin: value,
        end: endValue,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
        ),
      );

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

      controller.addListener(() {
        setState(() {
          model.userResponse[currentLineIndex].value = animation.value;
        });
      });

      controller.forward();
      isAnimating = true;
    }
  }

  void _loadAllCandles() async {
    model.uiCandles.clear();
    for (ui.Candle candle in model.candles
        .map((e) => ui.Candle(
            candleId: e.candleNum,
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
            volume: e.vol.round()))
        .toList()) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        model.uiCandles.add(candle);
      });
    }
  }

  void _loadCandlesTillAt() async {
    model.uiCandles.clear();
    for (ui.Candle candle in model.candles
        .map((e) => ui.Candle(
            candleId: e.candleNum,
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
            volume: e.vol.round()))
        .toList()) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (candle.dateTime.millisecondsSinceEpoch <= model.atTime) {
        setState(() {
          model.uiCandles.add(candle);
        });
      } else {
        break;
      }
    }
  }

  void _loadCandlesTillEnd() async {
    for (ui.Candle candle in model.candles
        .map((e) => ui.Candle(
            candleId: e.candleNum,
            open: e.open,
            high: e.high,
            low: e.low,
            close: e.close,
            dateTime: DateTime.fromMillisecondsSinceEpoch(e.time),
            volume: e.vol.round()))
        .toList()) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (candle.dateTime.millisecondsSinceEpoch > model.atTime) {
        setState(() {
          model.uiCandles.add(candle);
        });
      }
    }
  }
}
