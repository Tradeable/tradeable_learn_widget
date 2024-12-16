import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/utils/explanation_model.dart';

enum CandleSelectState {
  loadUI,
  submitResponse,
}

class CandleSelectModel {
  late String type;
  late String question;
  late List<int> correctResponse;
  late List<Candle> candles = [];
  late int atTime;
  late double yMax = 0;
  late double yMin = 0;
  late double helperHorizontalLineValue;
  List<int> selectedCandles = [];
  late int startTime;
  List<ui.Candle> uiCandles = [];
  bool isCorrect = false;
  late bool showChips;
  late String ticker;
  late String timeframe;

  CandleSelectState state = CandleSelectState.loadUI;
  ExplanationV1? explanationV1;

  CandleSelectModel.fromJson(dynamic data) {
    type = data["type"];
    question = data['question'];
    correctResponse = (data["selectedCandleIds"] as List)
        .map((e) => int.parse(e.toString()))
        .toList();
    candles =
        ((data["candles"]) as List).map((x) => Candle.fromJson(x)).toList();
    yMax = candles.fold<double>(0, (previousValue, element) {
      if (previousValue < element.high) {
        return element.high;
      } else {
        return previousValue;
      }
    });

    yMin = candles.fold<double>(yMax, (previousValue, element) {
      if (previousValue > element.low) {
        return element.low;
      } else {
        return previousValue;
      }
    });

    helperHorizontalLineValue = yMax - (yMax - yMin) / 2;
    showChips = data.containsKey("showChips") ? data["showChips"] : false;
    ticker = data.containsKey("ticker") ? data["ticker"] : "";
    timeframe = data.containsKey("timeframe") ? data["timeframe"] : "";
    explanationV1 = data["explanation"] != null
        ? ExplanationV1(
            forCorrect: (data["explanation"]["forCorrect"] as List<dynamic>?)
                ?.map((e) => ExplainerV1.fromJson(e))
                .toList(),
            forIncorrect:
                (data["explanation"]["forIncorrect"] as List<dynamic>?)
                    ?.map((e) => ExplainerV1.fromJson(e))
                    .toList(),
          )
        : ExplanationV1(forCorrect: [
            ExplainerV1(
              title: "Correct",
              data: "You got it correct",
              imageUrl: "assets/btmsheet_correct.png",
            )
          ], forIncorrect: [
            ExplainerV1(
              title: "Incorrect",
              data: "You got it incorrect",
              imageUrl: "assets/btmsheet_incorrect.png",
            )
          ]);
    if (data.containsKey("atTime")) {
      atTime = data["atTime"];
    } else {
      atTime = candles.last.time;
    }
  }

  void onCandleSelect(ui.Candle candle) {
    for (ui.Candle c in uiCandles) {
      if (c.candleId == candle.candleId) {
        c.isSelected = !c.isSelected;
      }
    }
    if (selectedCandles.contains(candle.candleId) && !candle.isSelected) {
      selectedCandles.remove(candle.candleId);
    } else {
      selectedCandles.add(candle.candleId);
    }
  }
}

class Candle {
  String ticker;
  int candleNum;
  int time;
  double open;
  double high;
  double low;
  double close;
  double vol;

  Candle(
    this.ticker,
    this.candleNum,
    this.time,
    this.open,
    this.high,
    this.low,
    this.close,
    this.vol,
  );

  factory Candle.fromJson(Map<String, dynamic> json) {
    return Candle(
      json['ticker'],
      json['num'],
      json['time'],
      json['open'].toDouble(),
      json['high'].toDouble(),
      json['low'].toDouble(),
      json['close'].toDouble(),
      json['vol'].toDouble(),
    );
  }
}
