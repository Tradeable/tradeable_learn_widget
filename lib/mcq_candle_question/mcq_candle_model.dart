enum MCQCandleQuestionState { loadUI, submitResponse }

class MCQCandleModel {
  late String question;
  late List<String> options;
  late String correctResponse;
  String? userResponse;
  late int startTime;
  bool isCorrect = false;
  MCQCandleQuestionState state = MCQCandleQuestionState.loadUI;

  MCQCandleModel.fromJson(dynamic data) {
    question = data['question'];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    correctResponse = data["correctResponse"];
  }
}
