import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;
import 'package:tradeable_learn_widget/horizontal_line_question/reel_range_response.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/chart_layer.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/rr_layer/rr_layer.dart';
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';
import 'package:tradeable_learn_widget/utils/explanation_model.dart';

enum RRQuestionState { loadUI, submitResponse }

class RRModel {
  late String question;
  late List<ReelRangeResponse> responseRange;
  late List<Candle> candles = [];
  late int atTime;
  late double yMax = 0;
  late double yMin = 0;
  late double helperHorizontalLineValue;
  late int startTime;
  List<ui.Candle> uiCandles = [];
  List<ChartLayer> layers = [];
  late RRLayer rrLayer;
  RRQuestionState state = RRQuestionState.loadUI;
  bool isCorrect = false;
  late bool isLong;
  String resultText = "";
  late bool showChips;
  late String ticker;
  late String timeframe;
  ExplanationV1? explanationV1;
  late bool? loadCandlesTillEnd;
  late RRResponses? rrResponses;

  RRModel.fromJson(dynamic data) {
    question = data['question'];
    responseRange = ((data["rangeResponses"]) as List)
        .map((x) => ReelRangeResponse.fromJson(x))
        .toList();
    candles =
        ((data["candles"]) as List).map((x) => Candle.fromJson(x)).toList();
    atTime = data["atTime"];

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

    rrLayer = RRLayer(
        value: candles.where((element) => element.time <= atTime).last.close,
        target: candles.where((element) => element.time <= atTime).last.close +
            (yMax - yMin) * 0.33,
        stoploss:
            candles.where((element) => element.time <= atTime).last.close -
                (yMax - yMin) * 0.33,
        startAt:
            candles.indexWhere((element) => element.time > atTime) * 20 + 5,
        endAt: candles.length * 20 + 5);

    helperHorizontalLineValue = yMax - (yMax - yMin) / 2;
    isLong = isTradeLong();

    showChips = data.containsKey("showChips") ? data["showChips"] : false;
    ticker = data.containsKey("ticker") ? data["ticker"] : "";
    timeframe = data.containsKey("timeframe") ? data["timeframe"] : "";
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
    loadCandlesTillEnd = data["loadCandlesTillEnd"] ?? false;
    rrResponses = data["responses"] != null
        ? RRResponses.fromJson(data["responses"])
        : null;
  }

  bool isTradeLong() {
    double lastCandleClose = candles.last.close;
    for (Candle candle in candles) {
      if (candle.time < atTime) {
        lastCandleClose = candle.close;
      } else {
        break;
      }
    }
    return lastCandleClose < candles.last.close;
  }
}

class RRResponses {
  late String? targetHitS1;
  late String? stoplossHitS1;
  late String? targetHitS2;
  late String? stoplossHitS2;
  late String? infoText;
  late String? ambitiousTarget;

  RRResponses(
      {this.targetHitS1,
      this.stoplossHitS1,
      this.targetHitS2,
      this.stoplossHitS2,
      this.infoText,
      this.ambitiousTarget});

  factory RRResponses.fromJson(Map<String, dynamic> json) {
    return RRResponses(
      targetHitS1: json['targetHitS1'] ?? "",
      stoplossHitS1: json['stoplossHitS1'] ?? "",
      targetHitS2: json['targetHitS2'] ?? "",
      stoplossHitS2: json['stoplossHitS2'] ?? "",
      infoText: json['infoText'] ?? "",
      ambitiousTarget: json['ambitiousTarget'] ?? "",
    );
  }
}
