class PriceDecreaseModel {
  late String title;
  late String description;
  late String question;
  late String correctResponse;
  late List<String> options;
  late String bottomSheetText;
  late String bottomSheetImgSrc;

  PriceDecreaseModel.fromJson(dynamic data) {
    title = data["title"];
    description = data["description"];
    question = data["question"];
    correctResponse = data["correctResponse"];
    options = data["options"].cast<String>() as List<String>;
    bottomSheetText = data["bottomSheetText"];
    bottomSheetImgSrc = data["bottomSheetImgSrc"];
  }
}
