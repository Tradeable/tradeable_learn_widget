import 'package:flutter/material.dart';

enum CandleFormationState { selecting, submitted }

class CandleFormationV2Model {
  late String question;
  late List<String> wickOptions;
  late List<String> tailOptions;
  late List<String> bodyOptions;
  late List<String> correctOptions;
  String selectedWick = "";
  String selectedTail = "";
  String selectedBody = "";
  CandleFormationState state = CandleFormationState.selecting;
  bool isIncorrect = false;

  CandleFormationV2Model.fromJson(dynamic data) {
    question = data["question"];
    wickOptions =
        ((data["headOptions"]) as List).map((x) => x.toString()).toList();
    tailOptions =
        ((data["tailOptions"]) as List).map((x) => x.toString()).toList();
    bodyOptions =
        ((data["bodyOptions"]) as List).map((x) => x.toString()).toList();
    correctOptions =
        ((data["correctOptions"]) as List).map((x) => x.toString()).toList();
  }

  Color getColor(String option) {
    return option.contains('green') ? Colors.green : Colors.red;
  }

  double getContainerHeight(String type, String option, bool isSelected) {
    final isLong = option.contains('long');
    final baseHeight =
        type == 'body' ? (isLong ? 100 : 50) : (isLong ? 80 : 20);
    return baseHeight + (isSelected ? 20 : 0);
  }

  double getContainerWidth(String type, bool isSelected) {
    return type == 'body' ? (isSelected ? 50 : 40) : (isSelected ? 15 : 10);
  }
}
