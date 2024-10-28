enum MutualFundImageMcqState {
  loadUI,
  submitResponse,
}

class MutualFundImageMCQModel {
  late String question;
  late List<String> options;
  late List<String>? imgSrc;
  late String correctResponse;
  bool isCorrect = false;
  MutualFundImageMcqState state = MutualFundImageMcqState.loadUI;
  String? userResponse;

  MutualFundImageMCQModel.fromJson(dynamic data) {
    question = data['question'];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    imgSrc = ((data["imgSrc"]) as List).map((x) => x.toString()).toList();
    correctResponse = data["correctResponse"];
  }
}
