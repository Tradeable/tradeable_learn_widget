class ExitFeeCalculatorModel {
  late String question;
  late Map<String, String> inputValues;

  ExitFeeCalculatorModel.fromJson(dynamic data) {
    question = data["question"];
    inputValues = Map<String, String>.from(data["inputValues"] ?? {});
  }
}
