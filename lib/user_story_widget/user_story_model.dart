import 'user_story_data_model.dart';

enum CurrentStepState { mcqQuestion, takingTrade, executingTrade, completed }

class UserStoryModel {
  late UserStoryDataModel userStory;

  UserStoryModel.fromJson(dynamic data) {
    userStory = UserStoryDataModel.fromJson(data["userStory"] ?? {});
  }
}
