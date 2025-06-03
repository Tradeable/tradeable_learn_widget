// lib/order_type_v1/widgets/advanced_options.dart
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/ui_constants.dart';
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
                style: UIConstants.advancedOptionsStyle,
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
              color: UIConstants.labelBackgroundColor,
              borderRadius:
                  BorderRadius.circular(UIConstants.defaultBorderRadius),
              border: Border.all(
                color: UIConstants.primaryCardColor,
                width: 2,
              ),
            ),
            child: const AutoSizeText('VALIDITY',
                minFontSize: 8, maxLines: 1, style: UIConstants.labelStyle),
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
            color: UIConstants.primaryCardColor,
            borderRadius:
                BorderRadius.circular(UIConstants.defaultBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: UIConstants.fieldPadding,
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
              color: UIConstants.labelBackgroundColor,
              borderRadius:
                  BorderRadius.circular(UIConstants.defaultBorderRadius),
              border: Border.all(
                color: UIConstants.primaryCardColor,
                width: 2,
              ),
            ),
            child: const AutoSizeText('DISC. QUANTITY',
                maxLines: 1, minFontSize: 8, style: UIConstants.labelStyle),
          ),
        ),
      ],
    );
  }
}
