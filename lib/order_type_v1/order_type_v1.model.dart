import 'package:tradeable_learn_widget/order_type_v1/tutorial_manager.dart';

class OrderTypeV1 {
  final String stockName;
  final double currentPrice;
  final bool tutorialMode;
  final TutorialType? tutorialType;

  const OrderTypeV1({
    required this.stockName,
    required this.currentPrice,
    required this.tutorialMode,
    this.tutorialType,
  });

  factory OrderTypeV1.fromJson(Map<String, dynamic> json) {
    return OrderTypeV1(
      stockName: json['stockName'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      tutorialMode: json['tutorialMode'] as bool,
      tutorialType: TutorialType.fromString(json['tutorialId'] as String?),
    );
  }
}
