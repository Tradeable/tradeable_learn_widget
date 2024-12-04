import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';

enum MultipleMCQQuestionState {
  loadUI,
  submitResponse,
}

class MultipleMCQModel {
  late String question;
  late List<String> options;
  late List<String> correctResponse;
  late List<Candle> candles = [];
  List<ui.Candle> uiCandles = [];
  late int atTime;
  late double yMax = 0;
  late double yMin = 0;
  late double helperHorizontalLineValue;
  late List<String> userResponse = [];
  MultipleMCQQuestionState state = MultipleMCQQuestionState.loadUI;
  late int startTime;
  bool isCorrect = false;
  late bool showChips;
  late String ticker;
  late String timeframe;

  MultipleMCQModel.fromJson(dynamic data) {
    question = data['question'];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    correctResponse =
        ((data["correctResponse"]) as List).map((x) => x.toString()).toList();
    candles =
        (data["candles"] as List?)?.map((x) => Candle.fromJson(x)).toList() ??
            [];
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
    atTime = data["atTime"] ?? 0;
    showChips = data.containsKey("showChips") ? data["showChips"] : false;
    ticker = data.containsKey("ticker") ? data["ticker"] : "";
    timeframe = data.containsKey("timeframe") ? data["timeframe"] : "";
  }
}
