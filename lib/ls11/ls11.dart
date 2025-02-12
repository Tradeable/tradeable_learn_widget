import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/ls11/ls11_model.dart';
import 'package:tradeable_learn_widget/tradeable_chart/chart.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/axis_layer/axis_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle_setting.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/line_layer/line_layer.dart';
import 'package:tradeable_learn_widget/utils/chart_info_chips.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class LS11 extends StatefulWidget {
  final LS11Model model;
  final VoidCallback onNextClick;

  const LS11({super.key, required this.model, required this.onNextClick});

  @override
  State<LS11> createState() => _LS11State();
}

class _LS11State extends State<LS11> {
  late LS11Model model;

  @override
  void initState() {
    model = widget.model;
    loadAllCandles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.5,
            child: renderChart(),
          ),
          SizedBox(
              height: constraints.maxHeight * 0.5,
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
                        renderQuestion(),
                        feedbackWidget(),
                        const Spacer(),
                        renderSubmitBtn(),
                      ]),
                ],
              )),
        ],
      );
    });
  }

  Widget renderChart() {
    final colors = Theme.of(context).customColors;

    switch (model.state) {
      case LS11State.loadUI:
        return Chart(layers: [
          AxisLayer(
              settings: AxisSettings(
                  axisColor: Colors.white,
                  yAxistextColor: Colors.white,
                  yFreq: 10)),
          CandleLayer(
              settings: ChartCandleSettings(
                  bodyThickness: 20, adaptiveBodyThickness: true),
              onCandleSelect: (p0) {
                setState(() {
                  model.onCandleSelect(p0);
                });
              },
              candles: model.uiCandles),
          LineLayer(
            id: "main",
            value: model.helperHorizontalLineValue,
            color: Colors.blue,
            textColor: Colors.white,
            onUpdate: (p0) {
              setState(() {
                model.helperHorizontalLineValue = p0;
              });
            },
            lineColor: colors.primary,
          ),
        ], yMax: model.yMax, yMin: model.yMin);
      case LS11State.submitResponse:
        return Chart(layers: [
          AxisLayer(
              settings: AxisSettings(
                  axisColor: Colors.white,
                  yAxistextColor: Colors.white,
                  yFreq: 10)),
          CandleLayer(
              areCandlesPreSelected: true,
              settings: ChartCandleSettings(
                  bodyThickness: 20, adaptiveBodyThickness: true),
              candles: model.uiCandles),
          LineLayer(
            id: "main",
            value: model.helperHorizontalLineValue,
            color: Colors.blue,
            textColor: Colors.white,
            onUpdate: (p0) {
              setState(() {
                model.helperHorizontalLineValue = p0;
              });
            },
            lineColor: colors.primary,
          ),
        ], yMax: model.yMax, yMin: model.yMin);
    }
  }

  Widget renderQuestion() {
    return const Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Tap on the 2 candles to maximise your profit",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 4,
            ),
            Text(
              "( PS: Your return is the difference between the entry candles and exit candles close price )",
              style: TextStyle(
                  color: Colors.red, fontStyle: FontStyle.italic, fontSize: 13),
            ),
          ],
        ));
  }

  Widget feedbackWidget() {
    switch (model.state) {
      case LS11State.loadUI:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(model.profitIndicator,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white)),
            ),
          ],
        );
      case LS11State.submitResponse:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(model.profitIndicator,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: model.userProfit == model.expectedProfit
                          ? Colors.green
                          : Colors.red)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                  "Expected Profit : ${model.expectedProfit.toStringAsFixed(2)}(${model.expectedProfitPercentage.toStringAsFixed(2)}%)",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                  model.isLongTrade
                      ? "This was a long trade (buy low sell high) train your eyeballs to capture maximum price movement"
                      : "This was a short trade (sell high buy low) eyeball setting is key in executing trades",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        );
    }
  }

  Widget renderSubmitBtn() {
    switch (model.state) {
      case LS11State.loadUI:
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
                  // widget.model.acceptResponse();
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
      case LS11State.submitResponse:
        return Container();
    }
  }

  void showAnimation() {
    for (ui.Candle candle in model.uiCandles) {
      if (model.selectedCandleIds.contains(candle.candleId)) {
        setState(() {
          candle.selectedByModel = true;
          model.state = LS11State.submitResponse;
        });
      }
    }
    if (model.userProfit == model.expectedProfit) {
      setState(() {
        model.isCorrect = true;
      });
    }
    widget.onNextClick();
  }

  void loadAllCandles() async {
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
}
