// lib/order_type_v1/services/order_service.dart
import 'package:intl/intl.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/order_constants.dart';

class OrderService {
  static final NumberFormat _numberFormatter =
      NumberFormat('#,##,##0.00', 'en_IN');

  static String calculateMarginRequirement(
    double quantity,
    double currentPrice,
  ) {
    if (quantity == 0) return "0.00";
    return _numberFormatter.format(quantity * currentPrice);
  }

  static Map<String, dynamic> createOrderData({
    required String stockName,
    required double currentPrice,
    required String orderType,
    required String quantityText,
    required bool eMarginEnabled,
    required String priceType,
    required String validity,
    required String stopLossText,
    required String targetPriceText,
    required String disclosedQuantityText,
    required bool stopLossEnabled,
  }) {
    return {
      'stockName': stockName,
      'currentPrice': currentPrice,
      'orderType': orderType,
      'quantity': double.tryParse(quantityText),
      'eMarginEnabled': eMarginEnabled,
      'priceType': priceType,
      'validity': validity,
      'stopLoss': orderType == 'COVER' || stopLossEnabled
          ? double.tryParse(stopLossText)
          : null,
      'targetPrice':
          orderType == 'COVER' ? double.tryParse(targetPriceText) : null,
      'disclosedQuantity': double.tryParse(disclosedQuantityText),
    };
  }

  static String getOrderTypeDescription(String orderType) {
    return OrderConstants.orderTypeDescriptions[orderType] ?? '';
  }

  static String getPriceTypeDescription(String priceType) {
    return OrderConstants.priceTypeDescriptions[priceType] ?? '';
  }

  static String getValidityDescription(String validity) {
    const descriptions = {
      'DAY':
          'Order valid for the current trading day only. It gets canceled automatically at the end of the trading day if not executed.',
      'IOC':
          'Immediate or Cancel - Order is executed immediately (fully or partially). Any portion that cannot be executed immediately is canceled.',
      'GTD':
          'Good Till Date - Order remains active in the market until executed or until the specified date.',
    };
    return descriptions[validity] ?? '';
  }

  static void updateStopLossAndTarget({
    required double currentPrice,
    required stopLossController,
    required targetPriceController,
  }) {
    stopLossController.text =
        (currentPrice * OrderConstants.defaultStopLossMultiplier)
            .toStringAsFixed(2);
    targetPriceController.text =
        (currentPrice * OrderConstants.defaultTargetPriceMultiplier)
            .toStringAsFixed(2);
  }
}
