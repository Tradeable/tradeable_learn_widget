// lib/order_type_v1/widgets/product_selector.dart
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/ui_constants.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/pillbox_selector.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/order_constants.dart';

class ProductSelector extends StatelessWidget {
  final String selectedOrderType;
  final Function(String) onOrderTypeChanged;
  final bool Function(String) isEnabled;

  const ProductSelector({
    super.key,
    required this.selectedOrderType,
    required this.onOrderTypeChanged,
    required this.isEnabled,
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
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: UIConstants.secondaryCardColor,
                  borderRadius:
                      BorderRadius.circular(UIConstants.defaultBorderRadius),
                ),
                child: PillboxSelector(
                  options: OrderConstants.orderTypes,
                  selectedValue: selectedOrderType,
                  fontSize: 16,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  onSelected: onOrderTypeChanged,
                  isEnabled: (option) => isEnabled('product_$option'),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
              color: UIConstants.labelBackgroundColor,
              borderRadius:
                  BorderRadius.circular(UIConstants.defaultBorderRadius),
              border: Border.all(
                color: UIConstants.primaryCardColor,
                width: 2,
              ),
            ),
            child: const Text('PRODUCT', style: UIConstants.labelStyle),
          ),
        ),
      ],
    );
  }
}
