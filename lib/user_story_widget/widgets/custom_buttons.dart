import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/user_story_widget/models/custom_buttons_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class MultipleButtonsWidget extends StatelessWidget {
  final String buttonsFormat;
  final List<ButtonData> buttonsData;
  final VoidCallback onAction;

  const MultipleButtonsWidget(
      {super.key,
      required this.buttonsFormat,
      required this.buttonsData,
      required this.onAction});

  @override
  Widget build(BuildContext context) {
    return buttonsFormat == "horizontal"
        ? Row(
            children: buttonsData.map((button) {
              return Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: buttonWidget(button, context)),
              );
            }).toList(),
          )
        : Column(
            children: buttonsData.map((button) {
            return buttonWidget(button, context);
          }).toList());
  }

  Widget buttonWidget(ButtonData button, BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return InkWell(
      onTap: onAction,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xffF9F9F9),
            border: Border.all(color: const Color(0xffE2E2E2))),
        child: Center(
          child: Text(button.title,
              style: textStyles.mediumBold
                  .copyWith(color: colors.primary, fontSize: 16)),
        ),
      ),
    );
  }
}
