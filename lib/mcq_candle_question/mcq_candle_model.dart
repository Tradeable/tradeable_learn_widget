import 'package:tradeable_learn_widget/utils/explanation_model.dart';

enum MCQCandleQuestionState { loadUI, submitResponse }

class MCQCandleModel {
  late String question;
  late List<String> options;
  late String correctResponse;
  String? userResponse;
  late int startTime;
  bool isCorrect = false;
  MCQCandleQuestionState state = MCQCandleQuestionState.loadUI;
  ExplanationV1? explanationV1;

  MCQCandleModel.fromJson(dynamic data) {
    question = data['question'];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    correctResponse = data["correctResponse"];
    explanationV1 = data["explaination"] != null
        ? ExplanationV1(
            forCorrect: (data["explaination"]["forCorrect"] as List<dynamic>?)
                ?.map((e) => ExplainerV1.fromJson(e))
                .toList(),
            forIncorrect:
                (data["explaination"]["forIncorrect"] as List<dynamic>?)
                    ?.map((e) => ExplainerV1.fromJson(e))
                    .toList(),
          )
        : ExplanationV1(forCorrect: [
            ExplainerV1(
              title: "Correct",
              data: "You got it correct",
              imageUrl: "assets/btmsheet_correct.png",
            )
          ], forIncorrect: [
            ExplainerV1(
              title: "Incorrect",
              data: "You got it incorrect",
              imageUrl: "assets/btmsheet_incorrect.png",
            )
          ]);
  }
}
