import 'dart:math';

import 'package:tradeable_learn_widget/utils/explanation_model.dart';

enum CandleBodySelectState { loadUI, submitResponse }

class CandlePartSelectModel {
  late String question;
  late String correctAnswer;
  late String correctResponse;
  String? userResponse;
  final random = Random();
  double wickHeight = 0;
  double tailHeight = 0;
  double bodyHeight = 0;
  bool isBullish = true;
  CandleBodySelectState state = CandleBodySelectState.loadUI;
  late int startTime;
  bool isCorrect = false;
  ExplanationV1? explanationV1;

  CandlePartSelectModel.fromJson(dynamic data) {
    question = data['question'];
    correctResponse = data["correctResponse"];
    correctAnswer = correctResponse;
    wickHeight = next(60, 100).toDouble();
    tailHeight = next(60, 100).toDouble();
    bodyHeight = next(60, 200).toDouble();
    isBullish = random.nextBool();
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

  int next(int min, int max) => min + random.nextInt(max - min);
}
