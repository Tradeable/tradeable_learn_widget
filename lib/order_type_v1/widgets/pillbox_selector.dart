import 'package:flutter/material.dart';

class PillboxSelector extends StatelessWidget {
  final List<String> options;
  final String selectedValue;
  final Function(String) onSelected;
  final double? width;
  final double? height;
  final bool Function(String)? isEnabled;
  final bool Function(String)? isVisible; // Add this
  final double? fontSize;
  final EdgeInsets? padding;
  final double? borderRadius;
  final bool useFlexibleWidth;

  const PillboxSelector({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    this.width,
    this.height,
    this.isEnabled,
    this.isVisible, // Add this
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.useFlexibleWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    // Filter options based on visibility
    final visibleOptions =
        options.where((option) => isVisible?.call(option) ?? true).toList();

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Color(0xFFE2E2E2),
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
      ),
      child: Row(
        children: visibleOptions.map((option) {
          final bool isSelected = selectedValue == option;
          final bool enabled = isEnabled?.call(option) ?? true;

          Widget optionWidget = GestureDetector(
              onTap: enabled ? () => onSelected(option) : null,
              child: Container(
                padding: padding ??
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (enabled ? Color(0xFF97144D) : Colors.grey)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(borderRadius ?? 16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ]
                      : [],
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize ?? (visibleOptions.length > 2 ? 12 : 14),
                    color: isSelected
                        ? Colors.white
                        : (enabled ? Color(0xFF6E6E6E) : Colors.grey),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ));

          return useFlexibleWidth
              ? IntrinsicWidth(child: optionWidget)
              : Expanded(child: optionWidget);
        }).toList(),
      ),
    );
  }
}
