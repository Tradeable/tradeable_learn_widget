import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';

enum MCQState {
  loadUI,
  submitResponse,
}

class MCQModel {
  late String type;
  late String question;
  late List<String> options;
  late String correctResponse;
  late List<Candle> candles = [];
  List<ui.Candle> uiCandles = [];
  late int atTime;
  late double yMax = 0;
  late double yMin = 0;
  late double helperHorizontalLineValue;
  String? userResponse;
  MCQState state = MCQState.loadUI;
  bool isCorrect = false;
  late bool showChips;
  late String ticker;
  late String timeframe;

  MCQModel.fromJson(dynamic data) {
    type = data["type"];
    question = data['question'];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    correctResponse = data["correctResponse"];
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

    showChips = data.containsKey("showChips") ? data["showChips"] : false;
    ticker = data.containsKey("ticker") ? data["ticker"] : "";
    timeframe = data.containsKey("timeframe") ? data["timeframe"] : "";

    helperHorizontalLineValue = yMax - (yMax - yMin) / 2;
    atTime = data["atTime"];
  }
}
