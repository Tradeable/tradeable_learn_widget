import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/constants.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class QuestionWidget extends StatelessWidget {
  final String question;

  const QuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    switch (currentStyle) {
      case QuestionStyleType.plain:
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(question,
                textAlign: TextAlign.start, style: textStyles.mediumNormal));
      case QuestionStyleType.withPrefix:
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(text: "Q: ", style: textStyles.mediumBold),
              TextSpan(text: question, style: textStyles.mediumNormal),
            ])));
      case QuestionStyleType.withBorder:
        return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                border: Border.all(color: colors.borderColorSecondary),
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8),
            child: Text(question,
                textAlign: TextAlign.start, style: textStyles.mediumNormal));
    }
  }
}
