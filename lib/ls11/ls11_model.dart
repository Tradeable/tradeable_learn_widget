import 'package:tradeable_learn_widget/candle_select_question/candle_select_model.dart';
import 'package:tradeable_learn_widget/tradeable_chart/layers/candle_layer.dart/candle.dart'
    as ui;

enum LS11State { loadUI, submitResponse }

class LS11Model {
  List<int> selectedCandleIds = [];
  late List<Candle> candles = [];
  late double expectedProfit;
  late double expectedProfitPercentage;
  late bool isLongTrade;
  late double yMax = 0;
  late double yMin = 0;
  late double helperHorizontalLineValue;
  List<int> selectedCandles = [];
  late int startTime;
  List<ui.Candle> uiCandles = [];
  LS11State state = LS11State.loadUI;
  bool isCorrect = false;

  late double userProfit;
  late double userProfitPercentage;

  String profitIndicator = "";
  late bool showChips;
  late String ticker;
  late String timeframe;

  LS11Model.fromJson(dynamic data) {
    candles =
        ((data["candles"]) as List).map((x) => Candle.fromJson(x)).toList();
    selectedCandleIds = (data["selectedCandleIds"] as List)
        .map((e) => int.parse(e.toString()))
        .toList();
    expectedProfit = data["expectedProfit"].toDouble();
    expectedProfitPercentage = data["expectedProfitPercent"].toDouble();
    isLongTrade = data["isLongTrade"];
    userProfit = 0;
    userProfitPercentage = 0;

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
  }

  void onCandleSelect(ui.Candle candle) {
    if (!candle.isSelected && selectedCandles.length == 2) {
      return;
    }
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
    selectedCandles.sort();
    if (selectedCandles.length == 2) {
      Candle candle1 = candles
          .firstWhere((element) => element.candleNum == selectedCandles[0]);
      Candle candle2 = candles
          .firstWhere((element) => element.candleNum == selectedCandles[1]);
      userProfit = (candle2.close - candle1.close).abs();
      if (candle2.close - candle1.close > 0) {
        isLongTrade = true;
        userProfitPercentage = (userProfit / candle1.close) * 100;
      } else {
        isLongTrade = false;
        userProfitPercentage = (userProfit / candle1.close) * 100;
      }
      profitIndicator =
          "Your Profit : ${userProfit.toStringAsFixed(2)} (${userProfitPercentage.toStringAsFixed(2)}%)";
    } else {
      profitIndicator = "";
    }
  }
}
