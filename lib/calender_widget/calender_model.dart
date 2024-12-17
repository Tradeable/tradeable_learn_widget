class CalenderQuestionModel {
  late String question;
  late List<String> correctResponses;
  late String initialDate;
  late String endDate;
  late bool isCorrect;

  CalenderQuestionModel.fromJson(dynamic data) {
    question = data["question"];
    correctResponses = List<String>.from(data["correctResponse"]);
    initialDate = data["start_date"];
    endDate = data["end_date"];
  }
}
