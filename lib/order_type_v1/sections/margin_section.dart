// lib/order_type_v1/widgets/margin_section.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/custom_switch.dart';

class MarginSection extends StatelessWidget {
  final String selectedOrderType;
  final bool eMarginEnabled;
  final String marginRequirementText;
  final bool Function(String) isEnabled;
  final Function(bool)? onEMarginChanged;

  const MarginSection({
    super.key,
    required this.selectedOrderType,
    required this.eMarginEnabled,
    required this.marginRequirementText,
    required this.isEnabled,
    this.onEMarginChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (selectedOrderType == 'DELIVERY') ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF0F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 35,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F6EB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const AutoSizeText(
                    'E-Margin',
                    minFontSize: 8,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF6E6E6E),
                    ),
                  ),
                ),
                CustomSwitch(
                  value: eMarginEnabled,
                  onChanged:
                      isEnabled('e_margin_toggle') ? onEMarginChanged : null,
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.02),
        ],
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF0F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F6EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const AutoSizeText(
                  'Required Margin',
                  minFontSize: 8,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF6E6E6E),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: selectedOrderType == 'DELIVERY' ? 15 : 5,
                ),
                child: Text(
                  '₹$marginRequirementText',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6E6E6E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
