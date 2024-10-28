class MfCalculatorModel {
  late String question;

  MfCalculatorModel.fromJson(dynamic data) {
    question = data["question"];
  }
}