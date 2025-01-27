import 'package:tradeable_learn_widget/utils/explanation_model.dart';
import 'user_story_data_model.dart';

enum CurrentStepState { mcqQuestion, takingTrade, executingTrade, completed }

class UserStoryModel {
  late UserStoryDataModel userStory;
  ExplanationV1? explanationV1;

  UserStoryModel.fromJson(dynamic data) {
    userStory =
        UserStoryDataModel.fromJson(data["userStory"] ?? {});
    explanationV1 = data["explaination"] != null
        ? ExplanationV1(
            forCorrect: (data["explaination"]["forCorrect"] as List<dynamic>?)
                ?.map((e) => ExplainerV1.fromJson(e as Map<String, dynamic>))
                .toList(),
            forIncorrect: (data["explaination"]["forIncorrect"]
                    as List<dynamic>?)
                ?.map((e) => ExplainerV1.fromJson(e as Map<String, dynamic>))
                .toList(),
          )
        : ExplanationV1(
            forCorrect: [
              ExplainerV1(
                title: "Correct",
                data: "You got it correct",
                imageUrl: "assets/btmsheet_correct.png",
              )
            ],
            forIncorrect: [
              ExplainerV1(
                title: "Incorrect",
                data: "You got it incorrect",
                imageUrl: "assets/btmsheet_incorrect.png",
              )
            ],
          );
  }
}
