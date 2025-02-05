import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

enum CurrentStepState { mcqQuestion, takingTrade, executingTrade, completed }

class UserStoryModel {
  late UserStoryDataModel userStory;

  UserStoryModel.fromJson(dynamic data) {
    userStory = UserStoryDataModel.fromJson(data["userStory"] ?? {});
  }
}
