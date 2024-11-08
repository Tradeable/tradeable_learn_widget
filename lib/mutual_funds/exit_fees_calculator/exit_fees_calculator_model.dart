class ExitFeeCalculatorModel {
  late String question;
  late Map<String, String> inputValues;
  late String program;

  ExitFeeCalculatorModel.fromJson(dynamic data) {
    question = data["question"];
    inputValues = Map<String, String>.from(data["inputValues"] ?? {});
    program = data["program"] ?? '';
  }
}
