import 'package:tradeable_learn_widget/utils/explanation_model.dart';

enum CandlePartMatchLinkState { loadUI, submitResponse }

class CandleMatchThePairModel {
  late List<String> pairFor;
  late bool isBullish;
  late int startTime;
  CandlePartMatchLinkState state = CandlePartMatchLinkState.loadUI;
  ExplanationV1? explanationV1;

  bool isCorrect = false;

  CandleMatchThePairModel.fromJson(dynamic data) {
    pairFor = (data["pairFor"] as List).map((e) => e.toString()).toList();
    isBullish = data["isBullish"];
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
