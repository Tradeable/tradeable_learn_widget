enum RangeGridSliderState { loadUi, submitResponse }

class RangeGridSliderModel {
  late String question;
  late String imageUrl;
  late List<String> options;
  late String correctResponse;
  late String userResponse;
  RangeGridSliderState state = RangeGridSliderState.loadUi;
  bool isCorrect = false;

  RangeGridSliderModel.fromJson(dynamic data) {
    question = data["question"];
    imageUrl = data["imageUrl"] ?? "";
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    correctResponse = data["correctResponse"];
  }
}
