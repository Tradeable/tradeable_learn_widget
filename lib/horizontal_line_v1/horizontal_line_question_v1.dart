import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/horizontal_line_v1/horizontal_line_model_v1.dart';
import 'package:tradeable_learn_widget/horizontal_line_v1/reel_range_response_v1.dart';
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
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class HorizontalLineQuestionV1 extends StatefulWidget {
  final HorizontalLineModelV1 model;
  final VoidCallback onNextClick;

  const HorizontalLineQuestionV1(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<HorizontalLineQuestionV1> createState() =>
      _HorizontalLineQuestionState();
}

class _HorizontalLineQuestionState extends State<HorizontalLineQuestionV1>
    with TickerProviderStateMixin {
  late HorizontalLineModelV1 model;
  bool isAnimating = false;

  @override
  void initState() {
    model = widget.model;
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
          QuestionWidget(question: model.question),
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
          renderSubmitBtn(),
        ],
      );
    });
  }

  Widget renderChart() {
    final colors = Theme.of(context).customColors;

    switch (model.state) {
      case HorizontalLineV1QuestionState.loadUI:
      case HorizontalLineV1QuestionState.submitResponse:
        return Chart(layers: [
          AxisLayer(
              settings: AxisSettings(
                  axisColor: colors.axisColor,
                  yAxistextColor: colors.axisColor,
                  yFreq: 10)),
          ...model.userResponse.map(
            (e) {
              return LineLayer(
                id: e.id,
                value: e.value,
                color: const Color(0xffF9B0CC),
                textColor: colors.axisColor,
                onUpdate: (p0) {
                  setState(() {
                    model.userResponse
                        .firstWhere((element) => element.id == e.id)
                        .value = p0;
                  });
                },
                lineColor: colors.borderColorPrimary,
              );
            },
          ),
          CandleLayer(
              settings: ChartCandleSettings(
                  bodyThickness: 8,
                  adaptiveBodyThickness: true,
                  shadowColor: colors.axisColor),
              candles: model.uiCandles),
          ...model.correctResponseLayer
        ], yMax: model.yMax, yMin: model.yMin);
    }
  }

  Widget renderSubmitBtn() {
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      child: ButtonWidget(
          color: colors.primary,
          btnContent: "Submit",
          onTap: () {
            showAnimation();
          }),
    );
  }

  void showAnimation() {
    setState(() {
      model.state = HorizontalLineV1QuestionState.submitResponse;
    });
    if (!widget.model.type.contains("STATIC")) {
      _loadCandlesTillEnd();
    }
    for (ReelRangeResponseV1 reelRangeResponse in model.responseRange) {
      setState(() {
        model.correctResponseLayer.add(RangeLayer(
            value1: max(reelRangeResponse.max, reelRangeResponse.min),
            value2: min(reelRangeResponse.max, reelRangeResponse.min),
            color: const Color.fromARGB(100, 50, 100, 29)));
      });

      bool isCorrectForResponse = model.userResponse.any((userResponse) =>
          min(reelRangeResponse.min, reelRangeResponse.max) <=
              userResponse.value &&
          max(reelRangeResponse.min, reelRangeResponse.max) >=
              userResponse.value);

      reelRangeResponse.isCorrect = isCorrectForResponse;
    }

    int correctCount = 0;
    for (ReelRangeResponseV1 reelRangeResponse in model.responseRange) {
      for (var element in model.userResponse) {
        if (min(reelRangeResponse.min, reelRangeResponse.max) <=
                element.value &&
            max(reelRangeResponse.min, reelRangeResponse.max) >=
                element.value) {
          setState(() {
            correctCount++;
          });
        }
      }
    }

    if (correctCount == model.userResponse.length) {
      setState(() {
        model.isCorrect = true;
      });
    } else {
      setState(() {
        model.isCorrect = false;
      });
    }
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => BottomSheetWidget(
            isCorrect: model.isCorrect,
            model: model.explanationV1,
            onNextClick: () {
              widget.onNextClick();
            }));
    // finish(widget.node.edges?.first.pathId ?? "finished", model.isCorrect);
  }

  void showSheet() {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 300, child: renderChart()),
                  Text(model.isCorrect ? "Great!" : "Incorrect",
                      style: textStyles.largeBold),
                  Text("Explanation goes here", style: textStyles.smallNormal),
                  const SizedBox(height: 20),
                  ButtonWidget(
                      color: colors.primary,
                      btnContent: "Next",
                      onTap: () {
                        widget.onNextClick();
                      }),
                ],
              ),
            ),
          );
        });
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
      for (int i = 0; i < model.userResponse.length; i++) {
        final value = model.userResponse[i].value;
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
            model.userResponse[i].value = animation.value;
          });
        });

        controller.forward();
      }

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
