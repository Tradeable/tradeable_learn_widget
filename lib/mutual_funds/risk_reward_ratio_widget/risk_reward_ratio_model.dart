class RiskRewardRatioModel {
  final dynamic data;
  late String title;
  late String description;
  late List<String> riskLevels;
  late Map<String, String> rewardRanges;

  RiskRewardRatioModel(this.data) {
    title = data['title'];
    description = data['description'];
    riskLevels = List<String>.from(data['riskLevels']);
    rewardRanges = Map<String, String>.from(data['rewardRanges']);
  }
}
