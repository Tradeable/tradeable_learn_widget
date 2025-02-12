import 'dart:math';
import 'package:flutter/material.dart';

enum CandleFormationState { loadUI, submitResponse }

class CandleFormationModel {
  late String question;
  late List<CandleOption> options;
  late List<String>? incorrectResponse;
  List<String>? userResponse;
  CandleFormationState state = CandleFormationState.loadUI;
  late int startTime;
  bool isCorrect = false;
  final random = Random();
  double wickHeight = 0;
  double tailHeight = 0;
  double bodyHeight = 0;
  late Color candleColor;
  List<String> selectedOptions = [];

  CandleFormationModel.fromJson(dynamic data) {
    question = data['question'];
    options = ((data["options"]) as List)
        .map((x) => CandleOption.fromJson(x))
        .toList();
    if (data.containsKey("incorrectResponse")) {
      incorrectResponse = ((data["incorrectResponse"]) as List)
          .map((x) => x.toString())
          .toList();
    } else {
      incorrectResponse = [];
    }
    candleColor = Random().nextInt(2) == 0 ? Colors.red : Colors.green;
  }

  void changeCandleColor(Color color) {
    candleColor = color;
  }

  void toggleOptionSelection(String option) {
    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      if (option.contains('wick')) {
        selectedOptions.removeWhere((element) => element.contains('wick'));
      } else if (option.contains('body')) {
        selectedOptions.removeWhere((element) => element.contains('body'));
      } else if (option.contains('tail')) {
        selectedOptions.removeWhere((element) => element.contains('tail'));
      }
      selectedOptions.add(option);
    }

    if (option.contains("body")) {
      if (option.contains("green")) {
        changeCandleColor(Colors.green);
      } else if (option.contains("red")) {
        changeCandleColor(Colors.red);
      }
    }

    selectedOptions.sort((a, b) {
      final optionA = _getOptionOrder(a);
      final optionB = _getOptionOrder(b);
      return optionA.order - optionB.order;
    });
  }

  Option _getOptionOrder(String option) {
    if (option.toLowerCase().contains('wick')) {
      return Option.wick;
    } else if (option.toLowerCase().contains('body')) {
      return Option.body;
    } else if (option.toLowerCase().contains('tail')) {
      return Option.tail;
    }
    return Option.wick;
  }

  int next(int min, int max) => min + random.nextInt(max - min);
}

enum Option {
  wick,
  tail,
  body,
}

extension OptionOrdering on Option {
  int get order {
    switch (this) {
      case Option.wick:
        return 0;
      case Option.body:
        return 1;
      case Option.tail:
        return 2;
      default:
        throw Exception("Unknown option");
    }
  }
}

class CandleOption {
  final String displayName;
  final String optionId;
  final String candleColor;

  CandleOption(
      {required this.displayName,
      required this.optionId,
      required this.candleColor});

  factory CandleOption.fromJson(Map<String, dynamic> json) {
    return CandleOption(
        displayName: json['displayName'],
        optionId: json['optionId'],
        candleColor: json['candleColor']);
  }
}
