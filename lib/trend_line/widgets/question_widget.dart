import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class QuestionWidget extends StatelessWidget {
  final String question;

  const QuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(question, style: textStyles.smallNormal),
    );
  }
}
