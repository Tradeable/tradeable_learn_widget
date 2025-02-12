import 'package:tradeable_learn_widget/ladder_widget/ladder_data_model.dart';

class ColumnDataModel {
  final bool isQuestion;
  final String position;
  final String value;

  ColumnDataModel(this.position, this.value, this.isQuestion);

  factory ColumnDataModel.fromJson(Map<String, dynamic> json) {
    return ColumnDataModel(
      json['position'] as String,
      json['value'] as String,
      json['isQuestion'] as bool,
    );
  }
}

class ColumnModel {
  late String? title;
  late String question;
  late List<ColumnCell> phraseColumn;
  late List<ColumnCell> valueColumn;

  ColumnModel.fromJson(dynamic data) {
    title = data["title"] ?? "";
    question = data["question"];
    phraseColumn = (data["phrase_column"] as List)
        .map((e) => ColumnCell(ColumnDataModel.fromJson(e)))
        .toList();
    valueColumn = (data["value_column"] as List)
        .map((e) => ColumnCell(ColumnDataModel.fromJson(e)))
        .toList();
  }
}

class ColumnDraggableOption {
  final String position;
  final String option;
  DraggableOptionState state;
  bool isSnappedCorrectly;

  ColumnDraggableOption(
      {required this.position,
      required this.option,
      this.state = DraggableOptionState.origin,
      this.isSnappedCorrectly = false});
}

class ColumnCell {
  ColumnDataModel model;
  ColumnDraggableOption? capturedOption;

  ColumnCell(this.model);
}

class ColumnUnit {
  final ColumnCell phrase;
  final ColumnCell value;

  ColumnUnit({required this.phrase, required this.value});
}
