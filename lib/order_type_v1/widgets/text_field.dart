import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/ui_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  // final String subtitle;
  final bool enabled;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final TextInputType keyboardType;
  final String? suffix;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    // required this.subtitle,
    this.enabled = true,
    this.onIncrement,
    this.onDecrement,
    this.keyboardType = TextInputType.number,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        decoration: BoxDecoration(
          color: UIConstants.textFieldBackgroundColor,
          borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        ),
        child: Row(
          children: [
            if (onDecrement != null)
              GestureDetector(
                onTap: enabled ? onDecrement : null,
                child: SizedBox(
                  width: math.max(32, MediaQuery.of(context).size.width * 0.07),
                  height:
                      math.max(32, MediaQuery.of(context).size.width * 0.07),
                  child: Icon(
                    Icons.remove,
                    color: UIConstants.textFieldIconColor,
                    size:
                        math.max(18, MediaQuery.of(context).size.width * 0.07),
                  ),
                ),
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: UIConstants.textFieldAccentColor,
                            borderRadius: BorderRadius.circular(
                                UIConstants.smallBorderRadius),
                          ),
                          child: TextField(
                            controller: controller,
                            textAlign: TextAlign.center,
                            keyboardType: keyboardType,
                            enabled: enabled,
                            readOnly: !enabled,
                            onChanged: onChanged,
                            style: UIConstants.textFieldStyle,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              fillColor: enabled
                                  ? null
                                  : UIConstants
                                      .textFieldAccentColor, // Keep white background
                              filled: !enabled, // Fill with white when disabled
                            ),
                          ),
                        ),
                      ),
                      if (suffix != null)
                        Text(
                          suffix!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (onIncrement != null)
              GestureDetector(
                onTap: enabled ? onIncrement : null,
                child: SizedBox(
                  width: math.max(32, MediaQuery.of(context).size.width * 0.07),
                  height:
                      math.max(32, MediaQuery.of(context).size.width * 0.07),
                  child: Icon(
                    Icons.add,
                    color: UIConstants.textFieldIconColor,
                    size:
                        math.max(18, MediaQuery.of(context).size.width * 0.07),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
