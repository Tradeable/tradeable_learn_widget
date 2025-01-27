import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class MCQQuestionWidgetV1 extends StatefulWidget {
  final String title;
  final String format;
  final List<String> options;
  final List<String> correctResponse;
  final void Function(List<String> selectedOptions) onOptionSelected;

  const MCQQuestionWidgetV1({
    super.key,
    required this.title,
    required this.format,
    required this.options,
    required this.correctResponse,
    required this.onOptionSelected,
  });

  @override
  State<StatefulWidget> createState() => _MCQQuestionWidgetV1State();
}

class _MCQQuestionWidgetV1State extends State<MCQQuestionWidgetV1> {
  List<String> selectedOptions = [];

  void toggleOption(String option) {
    setState(() {
      selectedOptions.clear();
      selectedOptions.add(option);
      widget.onOptionSelected(selectedOptions);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
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
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1 / 1.3,
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
    final isSelected = selectedOptions.contains(option);

    return InkWell(
      onTap: () => toggleOption(option),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected
                  ? colors.borderColorPrimary
                  : colors.buttonBorderColor),
        ),
        child: Center(
          child: Markdown(
            data: option,
            shrinkWrap: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(textAlign: WrapAlignment.center),
          ),
        ),
      ),
    );
  }
}
