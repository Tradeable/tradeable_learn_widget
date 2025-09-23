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

  factory OrderTypeV1.fromJson(dynamic data) {
    return OrderTypeV1(
      stockName: data['stockName'] as String,
      currentPrice: (data['currentPrice'] as num).toDouble(),
      tutorialMode: data['tutorialMode'] as bool,
      tutorialType: TutorialType.fromString(data['tutorialId'] as String?),
    );
  }
}
