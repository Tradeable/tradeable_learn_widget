import 'package:flutter/animation.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/reel_range_response.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/range_layer/range_layer.dart';

class HorizontalLineModel {
  late String type;
  late String question;
  late List<ReelRangeResponse> responseRange;
  late List<Candle> candles = [];
  late int atTime;
  late double yMax = 0;
  late double yMin = 0;
  late double helperHorizontalLineValue;
  late List<LineUserResponse> userResponse = [];
  List<ui.Candle> uiCandles = [];
  List<RangeLayer> correctResponseLayer = [];
  late AnimationController animationController;
  RangeLayer? animatingLayer;
  bool isCorrect = false;
  late bool showChips;
  late String ticker;
  late String timeframe;
  HorizontalLineQuestionState state = HorizontalLineQuestionState.loadUI;

  HorizontalLineModel.fromJson(dynamic data) {
    type = data['type'];
    question = data['question'];
    responseRange = ((data["rangeResponses"]) as List)
        .map((x) => ReelRangeResponse.fromJson(x))
        .toList();
    candles =
        ((data["candles"]) as List).map((x) => Candle.fromJson(x)).toList();
    atTime = data["atTime"];
    showChips = data.containsKey("showChips") ? data["showChips"] : false;
    ticker = data.containsKey("ticker") ? data["ticker"] : "";
    timeframe = data.containsKey("timeframe") ? data["timeframe"] : "";
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
  }
}

enum HorizontalLineQuestionState {
  loadUI,
  submitResponse,
}

class LineUserResponse {
  String id;
  double value;

  LineUserResponse(this.id, this.value);
}
