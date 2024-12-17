import 'package:tradeable_learn_widget/utils/explanation_model.dart';

enum MutualFundImageMcqState {
  loadUI,
  submitResponse,
}

class MutualFundImageMCQModel {
  late String question;
  late List<String> options;
  late List<String>? imgSrc;
  late String correctResponse;
  bool isCorrect = false;
  MutualFundImageMcqState state = MutualFundImageMcqState.loadUI;
  String? userResponse;
  ExplanationV1? explanationV1;

  MutualFundImageMCQModel.fromJson(dynamic data) {
    question = data['question'];
    options = ((data["options"]) as List).map((x) => x.toString()).toList();
    imgSrc = ((data["imgSrc"]) as List).map((x) => x.toString()).toList();
    correctResponse = data["correctResponse"];
    explanationV1 = data["explanation"] != null
        ? ExplanationV1(
            forCorrect: (data["explanation"]["forCorrect"] as List<dynamic>?)
                ?.map((e) => ExplainerV1.fromJson(e))
                .toList(),
            forIncorrect:
                (data["explanation"]["forIncorrect"] as List<dynamic>?)
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
