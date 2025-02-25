enum ImageMcqState {
  loadUI,
  submitResponse,
}

class ImageMCQModel {
  late String question;
  late List<String> options;
  late String? imgSrc;
  late String correctResponse;
  bool isCorrect = false;
  ImageMcqState state = ImageMcqState.loadUI;
  String? userResponse;

  ImageMCQModel.fromJson(dynamic data) {
    question = data['question'];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    imgSrc = data["imgSrc"] ?? "";
    correctResponse = data["correctResponse"];
  }
}
