// lib/order_type_v1/widgets/price_type_section.dart
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/ui_constants.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/pillbox_selector.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/text_field.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/order_constants.dart';

class PriceTypeSection extends StatelessWidget {
  final String priceType;
  final String selectedOrderType;
  final String validity;
  final double currentPrice;
  final TextEditingController targetPriceController;
  final Function(String) onPriceTypeChanged;
  final bool Function(String) isEnabled;
  final VoidCallback onTargetIncrement;
  final VoidCallback onTargetDecrement;

  const PriceTypeSection({
    super.key,
    required this.priceType,
    required this.selectedOrderType,
    required this.validity,
    required this.currentPrice,
    required this.targetPriceController,
    required this.onPriceTypeChanged,
    required this.isEnabled,
    required this.onTargetIncrement,
    required this.onTargetDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.018,
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.022,
          ),
          decoration: BoxDecoration(
            color: UIConstants.primaryCardColor,
            borderRadius:
                BorderRadius.circular(UIConstants.defaultBorderRadius),
          ),
          child: priceType == 'LIMIT'
              ? Container(
                  padding: UIConstants.fieldPadding,
                  child: CustomTextField(
                    controller: targetPriceController,
                    label: 'Limit Price',
                    onIncrement: onTargetIncrement,
                    onDecrement: onTargetDecrement,
                  ),
                )
              : SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(
                      currentPrice.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
        ),
        Center(
          child: PillboxSelector(
            fontSize: 14,
            width: 160,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            options: OrderConstants.priceTypes,
            selectedValue: priceType,
            onSelected: onPriceTypeChanged,
            isEnabled: (option) {
              if (validity == 'GTD' && option == 'MARKET') return false;
              if (selectedOrderType == 'COVER' && option == 'LIMIT')
                return false;
              return isEnabled('price_type_$option');
            },
          ),
        ),
      ],
    );
  }
}
