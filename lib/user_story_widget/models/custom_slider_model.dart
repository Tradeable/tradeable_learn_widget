class SliderData {
  final bool showDivision;
  final String title;
  final String subtext;
  final List<SliderPoint> sliderPoints;

  SliderData(
      {required this.showDivision,
      required this.sliderPoints,
      required this.title,
      required this.subtext});

  factory SliderData.fromJson(Map<String, dynamic> json) {
    return SliderData(
      title: json["title"] ?? "",
      subtext: json["subtext"] ?? "",
      showDivision: json["showDivision"] ?? false,
      sliderPoints: json["sliderPoints"] != null
          ? (json["sliderPoints"] as List)
              .map((point) => SliderPoint.fromJson(point))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "showDivision": showDivision,
      "sliderPoints": sliderPoints.map((point) => point.toJson()).toList(),
    };
  }
}

class SliderPoint {
  final double contractPrice;
  final double volatility;
  final double theta;
  final double delta;

  SliderPoint({
    required this.contractPrice,
    required this.volatility,
    required this.theta,
    required this.delta,
  });

  factory SliderPoint.fromJson(Map<String, dynamic> json) {
    return SliderPoint(
      contractPrice: json["contract_price"].toDouble(),
      volatility: json["volatility"].toDouble(),
      theta: json["theta"].toDouble(),
      delta: json["delta"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "contract_price": contractPrice,
      "volatility": volatility,
      "theta": theta,
      "delta": delta,
    };
  }
}
