class DynamicChartModel {
  late String recipeDataJson;

  DynamicChartModel.fromJson(dynamic data) {
    recipeDataJson = data["recipeDataJson"];
  }
}
