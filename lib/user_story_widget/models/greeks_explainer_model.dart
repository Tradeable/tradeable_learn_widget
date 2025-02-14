class GreeksExplainerModel {
  final String currentStrikePrice;
  final List<StrikePriceModel> strikePrices;
  final bool isCallOption;
  final bool isOptionToggleVisible;
  final List<String>? sliderLabels;
  final List<String>? premiumValues;
  final bool? showAnimation;
  final bool? showSliderLabels;
  final int stopValue;

  GreeksExplainerModel(
      {required this.currentStrikePrice,
      required this.strikePrices,
      required this.isCallOption,
      required this.isOptionToggleVisible,
      this.sliderLabels,
      this.premiumValues,
      this.showAnimation,
      this.showSliderLabels,
      required this.stopValue});

  factory GreeksExplainerModel.fromJson(Map<String, dynamic> json) {
    return GreeksExplainerModel(
        currentStrikePrice: json['currentStrikePrice'],
        strikePrices: (json['strikePrices'] as List)
            .map((e) => StrikePriceModel.fromJson(e))
            .toList(),
        isCallOption: json['isCallOption'],
        isOptionToggleVisible: json['isOptionToggleVisible'],
        sliderLabels:
            (json['sliderLabels'] as List?)?.map((e) => e as String).toList(),
        premiumValues:
            (json['premiumValues'] as List?)?.map((e) => e as String).toList(),
        showAnimation: json["showAnimation"] ?? false,
        showSliderLabels: json["showSliderLabels"] ?? false,
        stopValue: json["stopValue"] ?? 0);
  }
}

class StrikePriceModel {
  final String title;
  final String value;

  StrikePriceModel({required this.title, required this.value});

  factory StrikePriceModel.fromJson(Map<String, dynamic> json) {
    return StrikePriceModel(
      title: json['title'],
      value: json['value'],
    );
  }
}
