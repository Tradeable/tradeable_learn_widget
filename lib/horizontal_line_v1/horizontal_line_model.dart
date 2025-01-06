import 'package:flutter/animation.dart';
import 'package:tradeable_learn_widget/horizontal_line_v1/reel_range_response.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/range_layer/range_layer.dart';
import 'package:tradeable_learn_widget/utils/explanation_model.dart';

class HorizontalLineModelV1 {
  late String type;
  late String question;
  late List<ReelRangeResponseV1> responseRange;
  late List<Candle> candles = [];
  late int atTime;
  late double yMax = 0;
  late double yMin = 0;
  late double helperHorizontalLineValue;
  late List<HorizontalLineV1UserResponse> userResponse = [];
  List<ui.Candle> uiCandles = [];
  List<RangeLayer> correctResponseLayer = [];
  late AnimationController animationController;
  RangeLayer? animatingLayer;
  bool isCorrect = false;
  late bool showChips;
  late String ticker;
  late String timeframe;
  HorizontalLineV1QuestionState state = HorizontalLineV1QuestionState.loadUI;
  ExplanationV1? explanationV1;

  HorizontalLineModelV1.fromJson(dynamic data) {
    type = data['type'];
    question = data['question'];
    responseRange = ((data["rangeResponses"]) as List)
        .map((x) => ReelRangeResponseV1.fromJson(x))
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

enum HorizontalLineV1QuestionState {
  loadUI,
  submitResponse,
}

class HorizontalLineV1UserResponse {
  String id;
  double value;

  HorizontalLineV1UserResponse(this.id, this.value);
}
