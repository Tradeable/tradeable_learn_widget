import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/horizontal_line_model.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/reel_range_response.dart';
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
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/chart_info_chips.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class HorizontalLineQuestion extends StatefulWidget {
  final HorizontalLineModel model;

  const HorizontalLineQuestion({super.key, required this.model});

  @override
  State<HorizontalLineQuestion> createState() => _HorizontalLineQuestionState();
}

class _HorizontalLineQuestionState extends State<HorizontalLineQuestion>
    with TickerProviderStateMixin {
  late HorizontalLineModel model;
  bool isAnimating = false;

  @override
  void initState() {
    model = widget.model;
    initChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          renderQuestion(),
          const SizedBox(height: 20),
          SizedBox(height: constraints.maxHeight * 0.5, child: renderChart()),
          SizedBox(
              height: constraints.maxHeight * 0.25,
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
      case HorizontalLineQuestionState.loadUI:
      case HorizontalLineQuestionState.submitResponse:
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
                color: Colors.blue,
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

  Widget renderQuestion() {
    final textStyles = Theme.of(context).customTextStyles;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(model.question, style: textStyles.mediumNormal),
    );
  }

  Widget renderSubmitBtn() {
    final colors = Theme.of(context).customColors;

    switch (model.state) {
      case HorizontalLineQuestionState.loadUI:
        // return Container(
        //     height: 40,
        //     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        //     decoration: BoxDecoration(
        //       // color: defaultBgColor,
        //       borderRadius: const BorderRadius.all(Radius.circular(10)),
        //       border: Border.all(
        //         color: Colors.green,
        //       ),
        //     ),
        //     child: ClipRRect(
        //       borderRadius: const BorderRadius.all(Radius.circular(10)),
        //       child: MaterialButton(
        //         onPressed: () {
        //           // model.acceptResponse();
        //           showAnimation();
        //         },
        //         child: const Padding(
        //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //           child: Center(
        //             child: Text("Submit",
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontWeight: FontWeight.normal)),
        //           ),
        //         ),
        //       ),
        //     ));
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          child: ButtonWidget(
              color: colors.primary,
              btnContent: "Submit",
              onTap: () {
                showAnimation();
              }),
        );
      case HorizontalLineQuestionState.submitResponse:
        return Container();
    }
  }

  void showAnimation() {
    setState(() {
      model.state = HorizontalLineQuestionState.submitResponse;
    });
    if (!widget.model.type.contains("STATIC")) {
      _loadCandlesTillEnd();
    }
    for (ReelRangeResponse reelRangeResponse in model.responseRange) {
      setState(() {
        model.correctResponseLayer.add(RangeLayer(
            value1: max(reelRangeResponse.max, reelRangeResponse.min),
            value2: min(reelRangeResponse.max, reelRangeResponse.min),
            color: const Color.fromARGB(100, 50, 100, 29)));
      });
    }
    int correctCount = 0;
    for (ReelRangeResponse reelRangeResponse in model.responseRange) {
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
    showSheet();
    //todo
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
                      color: colors.primary, btnContent: "Next", onTap: () {}),
                ],
              ),
            ),
          );
        });
  }

  void initChartData() {
    for (int i = 0; i < model.responseRange.length; i++) {
      model.userResponse.add(LineUserResponse(
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