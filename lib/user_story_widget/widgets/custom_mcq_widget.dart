import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';
import 'package:tradeable_learn_widget/user_story_widget/widgets/ticket_coupon_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CustomMCQWidget extends StatefulWidget {
  final String format;
  final String question;
  final List<UiData> ui;
  final Function(UiData) onOptionSelected;

  const CustomMCQWidget({
    super.key,
    required this.format,
    required this.question,
    required this.ui,
    required this.onOptionSelected,
  });

  @override
  State<CustomMCQWidget> createState() => _CustomMCQWidgetState();
}

class _CustomMCQWidgetState extends State<CustomMCQWidget> {
  UiData? selectedOption;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.question.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              widget.question,
              style: textStyles.smallBold,
            ),
          ),
        if (widget.format == 'column')
          ...widget.ui.map((item) {
            final isSelected = selectedOption == item;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedOption = item;
                });
                widget.onOptionSelected(item);
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 30),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.transparent
                      : colors.cardColorSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isSelected
                        ? colors.borderColorPrimary
                        : colors.cardColorSecondary,
                  ),
                ),
                child: _buildWidget(item),
              ),
            );
          }),
        if (widget.format == 'row')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1 / 1.3),
              itemCount: widget.ui.length,
              itemBuilder: (context, index) {
                final item = widget.ui[index];
                final isSelected = selectedOption == item;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = item;
                    });
                    widget.onOptionSelected(item);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.cardColorSecondary.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: isSelected
                            ? colors.borderColorPrimary
                            : colors.cardColorSecondary,
                      ),
                    ),
                    child: _buildWidget(item),
                  ),
                );
              },
            ),
          )
      ],
    );
  }

  Widget _buildWidget(UiData item) {
    switch (item.widget) {
      case "CouponWidget":
        return TicketCouponWidget(model: item.ticketCouponModel!);
      case "MarkdownText":
        return Center(
          child: Markdown(
            data: item.prompt,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(textAlign: WrapAlignment.center),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
