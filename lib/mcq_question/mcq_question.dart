import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/mcq_question/mcq_model.dart';
import 'package:tradeable_learn_widget/mcq_question/quiz_option_widget.dart';
import 'package:tradeable_learn_widget/tradeable_chart/chart.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/line_layer/line_layer.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/chart_info_chips.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class MCQQuestion extends StatefulWidget {
  final MCQModel model;
  final VoidCallback onNextClick;

  const MCQQuestion(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<MCQQuestion> createState() => _MCQQuestionState();
}

class _MCQQuestionState extends State<MCQQuestion> {
  late MCQModel model;

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
          renderQuestion(),
          const SizedBox(height: 20),
          SizedBox(
            height: constraints.maxHeight * 0.5,
            child: renderChart(),
          ),
          SizedBox(
              height: constraints.maxHeight * 0.4,
              child: Column(
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
                    const SizedBox(height: 10),
                    renderOptions(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ButtonWidget(
                          color: colors.primary,
                          btnContent: "Submit",
                          onTap: () {
                            showAnimation();
                          }),
                    )
                  ])),
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
      LineLayer(
        id: "main",
        value: model.helperHorizontalLineValue,
        color: const Color(0xffF9B0CC),
        textColor: colors.axisColor,
        lineColor: colors.borderColorPrimary,
        onUpdate: (p0) {
          setState(() {
            model.helperHorizontalLineValue = p0;
          });
        },
      ),
      CandleLayer(
          settings: ChartCandleSettings(
              bodyThickness: 8,
              adaptiveBodyThickness: true,
              shadowColor: colors.axisColor),
          candles: model.uiCandles),
    ], yMax: model.yMax, yMin: model.yMin);
  }

  Widget renderQuestion() {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: AutoSizeText(model.question,
          maxLines: 2, style: textStyles.mediumNormal),
    );
  }

  Widget renderOptions() {
    switch (model.state) {
      case MCQState.loadUI:
        return buildOptions(correctResponse: null);
      case MCQState.submitResponse:
        return buildOptions(correctResponse: model.correctResponse);
    }
  }

  Widget buildOptions({required String? correctResponse}) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 3,
      padding: const EdgeInsets.all(10),
      children: model.options
          .map(
            (e) => QuizQuestionOption(
                option: e,
                correctResponse: correctResponse,
                onTap: (option) {
                  setState(() {
                    if (model.state == MCQState.loadUI) {
                      setState(() {
                        model.userResponse = option;
                      });
                      // showAnimation();
                    }
                  });
                },
                selectedOption: model.userResponse),
          )
          .toList(),
    );
  }

  void showAnimation() {
    setState(() {
      model.state = MCQState.submitResponse;
    });
    if (!widget.model.type.contains("STATIC")) {
      _loadCandlesTillEnd();
    }
    if (model.correctResponse == model.userResponse) {
      setState(() {
        model.isCorrect = true;
      });
    }
    showSheet();
    //todo
    // Future.delayed(const Duration(seconds: 2)).then((value) {
    //   finish(widget.node.edges?.first.pathId ?? "finished", model.isCorrect);
    // });
  }

  void showSheet() {
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
    if (widget.model.type == "MCQ_STATIC") {
      _loadAllCandles();
    } else {
      _loadCandlesTillAt();
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
