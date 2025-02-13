class ContractDetailsModel {
  String title;
  List<ContractDetail> contractDetails;

  ContractDetailsModel({
    required this.title,
    required this.contractDetails,
  });

  factory ContractDetailsModel.fromJson(Map<String, dynamic> json) {
    return ContractDetailsModel(
      title: json['title'],
      contractDetails: (json['contractDetails'] as List)
          .map((detail) => ContractDetail.fromJson(detail))
          .toList(),
    );
  }
}

class ContractDetail {
  String ticker;
  String timeFrame;
  String timeline;
  bool isExpanded;
  bool isDisabled;
  bool? shouldAnimate;
  bool? isPartiallyAnimated;

  ContractDetail(
      {required this.ticker,
      required this.timeFrame,
      required this.timeline,
      required this.isExpanded,
      required this.isDisabled,
      this.shouldAnimate,
      this.isPartiallyAnimated});

  factory ContractDetail.fromJson(Map<String, dynamic> json) {
    return ContractDetail(
        ticker: json['ticker'],
        timeFrame: json['timeFrame'],
        timeline: json['timeline'],
        isExpanded: json['isExpanded'],
        isDisabled: json['isDisabled'],
        shouldAnimate: json['shouldAnimate'] ?? false,
        isPartiallyAnimated: json['isPartiallyAnimated'] ?? false);
  }
}
