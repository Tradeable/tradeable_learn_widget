enum DraggableOptionState { origin, dragging, snapped }

class DraggableOption {
  final String type;
  final String option;
  DraggableOptionState state;
  bool isSnappedCorrectly;

  DraggableOption(
      {required this.type,
      required this.option,
      this.state = DraggableOptionState.origin,
      this.isSnappedCorrectly = false});
}

class DraggableTarget {
  final String correctOption;
  DraggableOption? capturedOption;

  DraggableTarget({required this.correctOption});
}

class LadderUnit {
  final LadderCell phrase;
  final LadderCell value;

  LadderUnit({required this.phrase, required this.value});
}

class LadderModel {
  late String type;
  late String? title;
  late String question;
  late List<LadderCell> phraseColumn;
  late List<LadderCell> valueColumn;
  late String? content1;
  late String? content2;

  LadderModel.fromJson(dynamic data) {
    type = data["type"] ?? "";
    title = data["title"] ?? "";
    question = data["question"];
    phraseColumn = (data["phrase_column"] as List)
        .map((e) => LadderCell(LadderDataModel.fromJson(e), "phrase"))
        .toList();
    valueColumn = (data["value_column"] as List)
        .map((e) => LadderCell(LadderDataModel.fromJson(e), "value"))
        .toList();
    content1 = data["content1"] ?? "";
    content2 = data["content2"] ?? "";
  }
}

class LadderCell {
  LadderDataModel model;
  DraggableOption? capturedOption;
  String comingFrom;

  LadderCell(this.model, this.comingFrom);
}

class LadderDataModel {
  final bool isQuestion;
  final String value;

  LadderDataModel(this.isQuestion, this.value);

  factory LadderDataModel.fromJson(Map<String, dynamic> json) {
    return LadderDataModel(
      json['isQuestion'] as bool,
      json['value'] as String,
    );
  }
}
