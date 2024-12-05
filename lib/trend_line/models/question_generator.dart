import 'package:tradeable_learn_widget/trend_line/models/trendline_model.dart';

class TrendLineQuestionGenerator {
  static List<Question> generateQuestions(TrendLineModel model) {
    List<Question> questions = [];

    if (model.question1.isNotEmpty) {
      questions.add(Question(type: "line", question: model.question1));
    }

    if (model.question2.isNotEmpty) {
      questions.add(Question(
          type: "mcq",
          question: model.question2,
          options: model.options,
          correctResponse: model.correctResponse));
    }

    if (model.question3.isNotEmpty) {
      questions.add(Question(
          type: "mcq",
          question: model.question3,
          options: model.options2,
          correctResponse: model.correctResponse2));
    }

    if (model.content.isNotEmpty) {
      questions.add(Question(type: "content", question: model.content));
    }

    return questions;
  }
}

class Question {
  final String type;
  final String question;
  List<String>? options;
  String? correctResponse;

  Question(
      {required this.type,
      required this.question,
      this.options,
      this.correctResponse});
}
