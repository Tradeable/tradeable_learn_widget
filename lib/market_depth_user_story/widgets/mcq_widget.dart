import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class MCQQuestionWidget extends StatefulWidget {
  final String title;
  final String format;
  final List<String> options;
  final List<String> correctResponse;
  final void Function(List<String> selectedOptions) onOptionSelected;

  const MCQQuestionWidget({
    super.key,
    required this.title,
    required this.format,
    required this.options,
    required this.correctResponse,
    required this.onOptionSelected,
  });

  @override
  State<StatefulWidget> createState() => _MCQQuestionWidgetState();
}

class _MCQQuestionWidgetState extends State<MCQQuestionWidget> {
  List<String> selectedOptions = [];

  void toggleOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
      widget.onOptionSelected(selectedOptions);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                widget.title,
                style: textStyles.largeBold.copyWith(fontSize: 20),
              ),
            ),
          widget.format == "grid"
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3,
                  ),
                  itemCount: widget.options.length,
                  itemBuilder: (context, index) {
                    return optionWidget(widget.options[index], context);
                  },
                )
              : Column(
                  children: widget.options
                      .map((option) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: optionWidget(option, context),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget optionWidget(String option, BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;
    final isSelected = selectedOptions.contains(option);

    return InkWell(
      onTap: () => toggleOption(option),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? colors.selectedItemColor.withOpacity(0.1)
              : colors.buttonColor,
          border: Border.all(
              color: isSelected
                  ? colors.selectedItemColor
                  : colors.buttonBorderColor),
        ),
        child: Center(
          child: Text(
            option,
            style: textStyles.mediumBold
                .copyWith(color: colors.primary, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
