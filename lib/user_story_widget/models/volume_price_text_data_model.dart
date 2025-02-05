class VolumePriceTextData {
  final String volume;
  final String price;
  final String interpretation;

  VolumePriceTextData({
    required this.volume,
    required this.price,
    required this.interpretation,
  });

  factory VolumePriceTextData.fromJson(Map<String, dynamic> json) {
    return VolumePriceTextData(
      volume: json['volume'],
      price: json['price'],
      interpretation: json['interpretation'],
    );
  }
}
