// lib/order_type_v1/widgets/advanced_options.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/pillbox_selector.dart';
import 'package:tradeable_learn_widget/order_type_v1/widgets/text_field.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/order_constants.dart';

class AdvancedOptions extends StatelessWidget {
  final bool showAdvanced;
  final String validity;
  final String selectedOrderType;
  final TextEditingController disclosedQuantityController;
  final bool Function(String) isEnabled;
  final VoidCallback onToggleAdvanced;
  final Function(String) onValidityChanged;
  final VoidCallback onDisclosedIncrement;
  final VoidCallback onDisclosedDecrement;

  const AdvancedOptions({
    super.key,
    required this.showAdvanced,
    required this.validity,
    required this.selectedOrderType,
    required this.disclosedQuantityController,
    required this.isEnabled,
    required this.onToggleAdvanced,
    required this.onValidityChanged,
    required this.onDisclosedIncrement,
    required this.onDisclosedDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: isEnabled('advanced_toggle') ? onToggleAdvanced : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Advanced Options',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF6E6E6E),
                ),
              ),
              Icon(showAdvanced ? Icons.expand_less : Icons.expand_more),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.024),
        if (showAdvanced) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: _buildValiditySection(context),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              if (validity == 'DAY') ...[
                Flexible(
                  flex: 2,
                  child: _buildDisclosedQuantitySection(context),
                ),
              ] else ...[
                Flexible(flex: 2, child: Container()),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildValiditySection(BuildContext context) {
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
                  fontSize: 14,
                  options: OrderConstants.validityTypes,
                  selectedValue: validity,
                  onSelected: onValidityChanged,
                  isEnabled: (option) {
                    if (selectedOrderType == 'COVER' &&
                        (option == 'IOC' || option == 'GTD')) {
                      return false;
                    }
                    return true;
                  },
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
              'VALIDITY',
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

  Widget _buildDisclosedQuantitySection(BuildContext context) {
    return Stack(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: CustomTextField(
                  controller: disclosedQuantityController,
                  label: 'DISCLOSED QUANTITY',
                  enabled: isEnabled('quantity_controls'),
                  onIncrement: onDisclosedIncrement,
                  onDecrement: onDisclosedDecrement,
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
              'DISC. QUANTITY',
              maxLines: 1,
              minFontSize: 8,
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
