class DemandSupplyEduCornerModel {
  late String introMd;
  late List<MarketCondition> marketCondition;

  DemandSupplyEduCornerModel.fromJson(dynamic data) {
    introMd = data["intro_md"];
    marketCondition = (data["market_condition"] as List<dynamic>)
        .map((condition) => MarketCondition.fromJson(condition))
        .toList();
  }
}

class MarketCondition {
  final String bidPrice;
  final String askPrice;
  final String demand;
  final String supply;
  final String market;

  MarketCondition({
    required this.bidPrice,
    required this.askPrice,
    required this.demand,
    required this.supply,
    required this.market,
  });

  factory MarketCondition.fromJson(Map<String, dynamic> json) {
    return MarketCondition(
      bidPrice: json["bidPrice"],
      askPrice: json["askPrice"],
      demand: json["demand"],
      supply: json["supply"],
      market: json["market"],
    );
  }
}
