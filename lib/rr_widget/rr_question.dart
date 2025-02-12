import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/rr_widget/rr_model.dart';
import 'package:tradeable_learn_widget/tradeable_chart/chart.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/line_layer/line_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/rr_layer/rr_layer.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/chart_info_chips.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;

class RRQuestion extends StatefulWidget {
  final RRModel model;
  final VoidCallback onNextClick;

  const RRQuestion({super.key, required this.model, required this.onNextClick});

  @override
  State<RRQuestion> createState() => _RRQuestionState();
}

class _RRQuestionState extends State<RRQuestion> with TickerProviderStateMixin {
  late RRModel model;
  late AnimationController controller;
  bool isAnimating = false;

  @override
  void initState() {
    model = widget.model;
    _loadCandlesTillAt();
    animateLayer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: constraints.maxHeight * 0.5,
          child: renderChart(),
        ),
        SizedBox(
          height: constraints.maxHeight * 0.5,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            model.candles.isNotEmpty
                ? ChartInfoChips(
                    ticker: model.ticker,
                    timeFrame: model.timeframe,
                    date: DateFormat("dd MMM yyyy").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            model.candles.first.time)))
                : Container(),
            renderQuestion(),
            helperText(),
            const Spacer(),
            renderSubmitBtn()
          ]),
        )
      ]);
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
      LineLayer(
        id: "main",
        value: model.helperHorizontalLineValue,
        color: const Color(0xffF9B0CC),
        textColor: colors.axisColor,
        onUpdate: (p0) {
          setState(() {
            model.helperHorizontalLineValue = p0;
          });
        },
        lineColor: colors.primary,
      ),
      CandleLayer(
          settings: ChartCandleSettings(
              bodyThickness: 10,
              adaptiveBodyThickness: false,
              shadowColor: colors.axisColor),
          candles: model.uiCandles),
      model.rrLayer
        ..onUpdate = (p0, p1, p2, p3, p4) {
          setState(() {
            model.rrLayer = RRLayer(
                value: p0, target: p1, stoploss: p2, startAt: p3, endAt: p4);
          });
        },
    ], yMax: model.yMax, yMin: model.yMin);
  }

  Widget renderQuestion() {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(model.question,
          style: textStyles.mediumBold, textAlign: TextAlign.center),
    );
  }

  Widget renderSubmitBtn() {
    switch (model.state) {
      case RRQuestionState.loadUI:
        return Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Colors.green,
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: MaterialButton(
                onPressed: () {
                  showAnimation();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Center(
                    child: Text("Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal)),
                  ),
                ),
              ),
            ));
      case RRQuestionState.submitResponse:
        final colors = Theme.of(context).customColors;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color: colors.primary,
              btnContent: "Next",
              onTap: () {
                showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (context) => BottomSheetWidget(
                        isCorrect: model.isCorrect,
                        model: model.explanationV1,
                        onNextClick: () {
                          widget.onNextClick();
                        }));
              }),
        );
    }
  }

  void showAnimation() {
    setState(() {
      model.state = RRQuestionState.submitResponse;
    });
    _loadCandlesTillEnd();
    addRRValidText();
    widget.onNextClick();
  }

  Widget helperText() {
    final textStyles = Theme.of(context).customTextStyles;

    switch (model.state) {
      case RRQuestionState.loadUI:
        return Container();
      case RRQuestionState.submitResponse:
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Text(model.resultText, style: textStyles.mediumBold),
        );
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

  void animateLayer() {
    if (!isAnimating) {
      controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            isAnimating = false;
          }
        });

      List<Tween<double>> tweens = [
        Tween<double>(
          begin: model.rrLayer.target,
          end: model.rrLayer.target + 10,
        ),
        Tween<double>(
          begin: model.rrLayer.stoploss,
          end: model.rrLayer.stoploss - 10,
        ),
      ];

      List<Animation<double>> animations = tweens.map((tween) {
        return tween.animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
          ),
        );
      }).toList();

      for (int i = 0; i < animations.length; i++) {
        animations[i].addListener(() {
          setState(() {
            if (i == 0) {
              model.rrLayer.target = animations[i].value;
            }
            if (i == 1) {
              model.rrLayer.stoploss = animations[i].value;
            }
          });
        });
      }

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

      controller.forward();
    }
  }

  void _loadCandlesTillEnd() async {
    bool limitHit = false;
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
        if (!limitHit) {
          if (model.rrLayer.target > model.rrLayer.stoploss) {
            if (candle.close > model.rrLayer.target) {
              setState(() {
                limitHit = true;
                model.isCorrect = true;
                model.resultText = model.resultText.isEmpty
                    ? "- Yay!! You hit the target"
                    : "${model.resultText}\n- Yay!! You hit the target";
              });
            } else if (candle.close < model.rrLayer.stoploss) {
              setState(() {
                limitHit = true;
                model.resultText = model.resultText.isEmpty
                    ? "- Oops!! Stop loss was hit"
                    : "${model.resultText}\n- Oops!! Stop loss was hit";
              });
            }
          } else {
            if (candle.close < model.rrLayer.target) {
              setState(() {
                limitHit = true;
                model.isCorrect = true;
                model.resultText = model.resultText.isEmpty
                    ? "- Yay!! You hit the target"
                    : "${model.resultText}\n- Yay!! You hit the target";
              });
            } else if (candle.close > model.rrLayer.stoploss) {
              setState(() {
                limitHit = true;
                model.resultText = model.resultText.isEmpty
                    ? "- Oops!! Stop loss was hit"
                    : "${model.resultText}\n- Oops!! Stop loss was hit";
              });
            }
          }
        }
        setState(() {
          model.uiCandles.add(candle);
        });
      }
    }
    if (!limitHit) {
      model.resultText = model.resultText.isEmpty
          ? "- Target was to ambitious"
          : "${model.resultText}\n- Target was to ambitious";
    }
  }

  void addRRValidText() {
    if ((model.rrLayer.value - model.rrLayer.target).abs() /
            (model.rrLayer.value - model.rrLayer.stoploss).abs() <
        2) {
      model.resultText = "- Risk to Reward should be 2 or more";
    }
  }
}
