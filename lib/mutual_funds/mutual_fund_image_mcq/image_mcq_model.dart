enum MutualFundImageMcqState {
  loadUI,
  submitResponse,
}

class MutualFundImageMCQModel {
  final dynamic data;
  late String question;
  late List<String> options;
  late List<String>? imgSrc;
  late String correctResponse;
  bool isCorrect = false;
  MutualFundImageMcqState state = MutualFundImageMcqState.loadUI;
  String? userResponse;

  MutualFundImageMCQModel(this.data) {
    question = data['question'];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    imgSrc = ((data["imgSrc"]) as List).map((x) => x.toString()).toList();
    correctResponse = data["correctResponse"];
  }
}
