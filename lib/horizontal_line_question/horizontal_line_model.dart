import 'package:flutter/animation.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';
import 'package:tradeable_learn_widget/horizontal_line_question/reel_range_response.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/range_layer/range_layer.dart';
import 'package:tradeable_learn_widget/utils/explanation_model.dart';

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
  ExplanationV1? explanationV1;
  int? candleSpeed;

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
    candleSpeed = data.containsKey("candleSpeed") ? data["candleSpeed"] : 50;
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
    explanationV1 = data["explaination"] != null
        ? ExplanationV1(
            forCorrect: (data["explaination"]["forCorrect"] as List<dynamic>?)
                ?.map((e) => ExplainerV1.fromJson(e))
                .toList(),
            forIncorrect:
                (data["explaination"]["forIncorrect"] as List<dynamic>?)
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
