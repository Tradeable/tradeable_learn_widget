import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class OptionsEduCorner extends StatelessWidget {
  final Widget topSection;
  final Widget middleSection;
  final Widget explanationSection;
  final String title;
  final VoidCallback onNextPressed;

  const OptionsEduCorner(
      {super.key,
      required this.topSection,
      required this.middleSection,
      required this.explanationSection,
      required this.title,
      required this.onNextPressed});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(child: Text(title, style: textStyles.largeBold)),
        Expanded(flex: 4, child: topSection),
        const SizedBox(height: 20),
        Expanded(flex: 3, child: middleSection),
        const SizedBox(height: 30),
        Expanded(flex: 3, child: explanationSection),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonWidget(
                color: colors.primary,
                btnContent: 'Next',
                onTap: onNextPressed)),
      ],
    );
  }
}
