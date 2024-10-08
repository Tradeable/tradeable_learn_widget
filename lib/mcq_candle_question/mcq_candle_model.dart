enum MCQCandleQuestionState { loadUI, submitResponse }

class MCQCandleModel {
  final dynamic data;
  late String question;
  late List<String> options;
  late String correctResponse;
  String? userResponse;
  late int startTime;
  bool isCorrect = false;
  MCQCandleQuestionState state = MCQCandleQuestionState.loadUI;

  MCQCandleModel(this.data) {
    question = data['question'];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    correctResponse = data["correctResponse"];
  }
}
