// lib/order_type_v1/widgets/quantity_section.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/ui_constants.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/text_field.dart';

class QuantitySection extends StatelessWidget {
  final TextEditingController quantityController;
  final bool Function(String) isEnabled;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Function(String)? onChanged;

  const QuantitySection({
    super.key,
    required this.quantityController,
    required this.isEnabled,
    required this.onIncrement,
    required this.onDecrement,
    this.onChanged,
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
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  left: 8,
                  right: 8,
                ),
                child: CustomTextField(
                  controller: quantityController,
                  label: 'QUANTITY',
                  enabled: isEnabled('quantity_controls'),
                  onChanged: onChanged,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: UIConstants.primaryCardColor,
                width: 2,
              ),
            ),
            child: const AutoSizeText('QUANTITY',
                minFontSize: 8, maxLines: 1, style: UIConstants.labelStyle),
          ),
        ),
      ],
    );
  }
}
