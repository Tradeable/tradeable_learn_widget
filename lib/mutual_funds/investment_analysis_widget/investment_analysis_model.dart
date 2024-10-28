class InvestmentAnalysisModel {
  late String question;
  late String description;
  late List<double> chartData;

  InvestmentAnalysisModel.fromJson(dynamic data) {
    question = data["question"] ?? "";
    description = data["description"] ?? "";
    chartData =
        List<double>.from(data["chartData"].map((item) => item.toDouble()));
  }
}
