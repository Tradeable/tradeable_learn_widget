import 'package:tradeable_learn_widget/dynamic_chart/dynamic_chart_model.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/option_chain_model.dart';

class SampleUserflowModel {
  late DynamicChartModel dynamicChartModel;
  late OptionData optionsData;

  SampleUserflowModel.fromJson(dynamic json) {
    dynamicChartModel = DynamicChartModel.fromJson({"recipe": json["recipe"]});
    optionsData = OptionData.fromJson(json["optionData"]);
  }
}
