class InvestmentAnalysisModel {
  late String question;
  late List<double> chartData;

  InvestmentAnalysisModel.fromJson(dynamic data) {
    question = data["question"];
    chartData =
        List<double>.from(data["chartData"].map((item) => item.toDouble()));
  }
}
