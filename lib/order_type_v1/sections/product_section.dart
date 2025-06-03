// lib/order_type_v1/widgets/product_selector.dart
import 'package:flutter/material.dart';
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
            color: const Color(0xFFEBF0F9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E2E2),
                  borderRadius: BorderRadius.circular(15),
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
              color: const Color(0xFFF9F6EB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFEBF0F9),
                width: 2,
              ),
            ),
            child: const Text(
              'PRODUCT',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF6E6E6E),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
