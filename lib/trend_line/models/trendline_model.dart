import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';
import 'package:tradeable_learn_widget/fin_chart/models/fin_candle.dart';
import 'package:tradeable_learn_widget/trend_line/models/line_offset.dart';
import 'package:tradeable_learn_widget/trend_line/models/tag_offset.dart';

class TrendLineModel {
  late String title;
  late String question1;
  late String question2;
  late String question3;
  late bool isLineChart;
  late List<String> options;
  late List<String> options2;
  late String content;
  late String correctResponse;
  late String correctResponse2;
  String userResponse = "";
  late List<Candle> candles = [];
  late List<FinCandle> uiCandles = [];
  double yMax = 0;
  double yMin = 0;
  late List<TagOffset> pointLabels = [];
  late List<List<LineOffset>> lineOffsets = [];
  late List<UserPointLabelResponse> pointLabelResponse = [];
  late List<UserPointLabelResponse> pointLabelCorrectResponse = [];
  late List<List<UserLineResponse>> lineResponse = [];
  late List<List<UserLineResponse>> lineCorrectResponse = [];
  String userResponse2 = "";

  bool isCorrect = false;
  late int atTime;
  late bool showChips;
  late String ticker;
  late String timeframe;

  bool loadTillEndCandle = false;

  TrendLineModel.fromJson(dynamic data) {
    title = data["title"];
    question1 = data["question1"];
    question2 = data["question2"];
    question3 = data["question3"] ?? "";
    isLineChart = data["isLineChart"];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    options2 = data["options2"] != null
        ? ((data["options2"]) as List).map((x) => x.toString()).toList()
        : [];
    content = data["content"] ?? "";
    atTime = data["atTime"] ?? 0;
    correctResponse = data["correctResponse"];
    correctResponse2 = data["correctResponse2"] ?? "";
    candles =
        ((data["candles"]) as List).map((x) => Candle.fromJson(x)).toList();
    pointLabels = ((data["point_label"]) as List)
        .map((x) => TagOffset.fromJson(x))
        .toList();

    if (data["line_offsets"] != null) {
      lineOffsets = (data["line_offsets"] as List).map((list) {
        return (list as List).map((x) => LineOffset.fromJson(x)).toList();
      }).toList();
    } else {
      lineOffsets = [];
    }

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
    loadTillEndCandle = data.containsKey("loadTillEndCandle")
        ? data["loadTillEndCandle"]
        : false;
  }
}

class UserPointLabelResponse {
  String id;
  double pos;
  double value;
  Color color;

  UserPointLabelResponse(this.id, this.pos, this.value, this.color);
}

class UserLineResponse {
  String id;
  List<Offset> offset;
  Color color;

  UserLineResponse(this.id, this.offset, this.color);
}
