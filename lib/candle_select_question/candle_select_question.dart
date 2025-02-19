import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';
import 'package:tradeable_learn_widget/tradeable_chart/chart.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/line_layer/line_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/chart_info_chips.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CandleSelectQuestion extends StatefulWidget {
  final CandleSelectModel model;
  final VoidCallback onNextClick;

  const CandleSelectQuestion(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<CandleSelectQuestion> createState() => _CandleSelectQuestionState();
}

class _CandleSelectQuestionState extends State<CandleSelectQuestion> {
  late CandleSelectModel model;

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
          QuestionWidget(question: model.question),
          const SizedBox(height: 20),
          SizedBox(
            height: constraints.maxHeight * 0.5,
            child: renderChart(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (model.candles.isNotEmpty)
                  ChartInfoChips(
                    ticker: model.ticker,
                    timeFrame: model.timeframe,
                    date: DateFormat("dd MMM yyyy").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            model.candles.first.time)),
                  ),
                renderIndicator(),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: renderSubmitBtn(),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget renderChart() {
    final colors = Theme.of(context).customColors;

    switch (model.state) {
      case CandleSelectState.loadUI:
        return Chart(layers: [
          AxisLayer(
              settings: AxisSettings(
                  axisColor: colors.axisColor,
                  yAxistextColor: colors.axisColor,
                  yFreq: 10)),
          CandleLayer(
              settings: ChartCandleSettings(
                  bodyThickness: 20,
                  adaptiveBodyThickness: true,
                  shadowColor: colors.axisColor),
              onCandleSelect: (p0) {
                setState(() {
                  model.onCandleSelect(p0);
                });
              },
              shouldBlackOutCandles:
                  model.state == CandleSelectState.submitResponse,
              candles: model.uiCandles),
          LineLayer(
            id: "main",
            value: model.helperHorizontalLineValue,
            color: const Color(0xffF9B0CC),
            textColor: colors.axisColor,
            lineColor: colors.primary,
            onUpdate: (p0) {
              setState(() {
                model.helperHorizontalLineValue = p0;
              });
            },
          ),
        ], yMax: model.yMax, yMin: model.yMin);
      case CandleSelectState.submitResponse:
        return Chart(layers: [
          AxisLayer(
              settings: AxisSettings(
                  axisColor: colors.axisColor,
                  yAxistextColor: colors.axisColor,
                  yFreq: 10)),
          CandleLayer(
              areCandlesPreSelected: true,
              settings: ChartCandleSettings(
                  bodyThickness: 20,
                  adaptiveBodyThickness: true,
                  shadowColor: colors.axisColor),
              candles: model.uiCandles),
          LineLayer(
            id: "main",
            value: model.helperHorizontalLineValue,
            color: const Color(0xffF9B0CC),
            textColor: colors.axisColor,
            lineColor: colors.primary,
            onUpdate: (p0) {
              setState(() {
                model.helperHorizontalLineValue = p0;
              });
            },
          ),
        ], yMax: model.yMax, yMin: model.yMin);
    }
  }

  Widget renderIndicator() {
    switch (model.state) {
      case CandleSelectState.loadUI:
        return Container();
      case CandleSelectState.submitResponse:
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 20, height: 20, color: Colors.purple),
              const SizedBox(width: 5),
              const Text("Correct Response", style: TextStyle(fontSize: 13)),
              const SizedBox(width: 10),
              Container(
                  width: 20,
                  height: 20,
                  color: Colors.blue.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      width: 1,
                      height: 20,
                      color: Colors.white.withOpacity(0.0),
                    ),
                  )),
              const SizedBox(width: 5),
              const Text("Incorrect Response", style: TextStyle(fontSize: 13)),
            ],
          ),
        );
    }
  }

  Widget renderSubmitBtn() {
    final colors = Theme.of(context).customColors;

    switch (model.state) {
      case CandleSelectState.loadUI:
        return ButtonWidget(
            color: model.selectedCandles.isNotEmpty
                ? colors.primary
                : colors.secondary,
            btnContent: "Submit",
            onTap: () {
              if (model.selectedCandles.isNotEmpty) {
                showAnimation();
              }
            });
      case CandleSelectState.submitResponse:
        return ButtonWidget(
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
            });
    }
  }

  void showAnimation() async {
    setState(() {
      model.state = CandleSelectState.submitResponse;
    });
    for (ui.Candle candle in model.uiCandles) {
      if (model.correctResponse.contains(candle.candleId)) {
        candle.selectedByModel = true;
      }
    }
    if (!widget.model.type.contains("STATIC")) {
      _loadCandlesTillEnd();
    }
    model.selectedCandles.sort();
    model.correctResponse.sort();

    setState(() {
      model.isCorrect =
          listEquals(model.selectedCandles, model.correctResponse);
    });
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => BottomSheetWidget(
            isCorrect: model.isCorrect,
            model: model.explanationV1,
            onNextClick: () {
              widget.onNextClick();
            }));
    //todo
    // finish(widget.node.edges?.first.pathId ?? "finished", model.isCorrect);
  }

  void initChartData() {
    if (widget.model.type == "MultipleCandleSelect_STATIC") {
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
