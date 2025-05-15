import 'package:fin_chart/models/recipe.dart';

class DynamicChartModel {
  late Recipe recipe;

  DynamicChartModel.fromJson(dynamic data) {
    recipe = Recipe.fromJson(data["recipe"]);
  }
}
