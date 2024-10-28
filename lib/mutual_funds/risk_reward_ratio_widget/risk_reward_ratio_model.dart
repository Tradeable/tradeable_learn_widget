class RiskRewardRatioModel {
  final dynamic data;
  late String title;
  late String description;
  late List<String> riskLevels;
  late List<String> averageReturns;
  late List<Map<String, String>> fundDetails;

  RiskRewardRatioModel(this.data) {
    title = data['title'];
    description = data['description'];
    riskLevels = List<String>.from(data['riskLevels']);
    averageReturns = List<String>.from(data['averageReturns']);
    fundDetails = List<Map<String, String>>.from(
        data['fundDetails'].map((fund) => Map<String, String>.from(fund)));
  }
}
