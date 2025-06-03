// lib/order_type_v1/widgets/quantity_section.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
            color: const Color(0xFFEBF0F9),
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
              color: const Color(0xFFF9F6EB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFEBF0F9),
                width: 2,
              ),
            ),
            child: const AutoSizeText(
              'QUANTITY',
              minFontSize: 8,
              maxLines: 1,
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
