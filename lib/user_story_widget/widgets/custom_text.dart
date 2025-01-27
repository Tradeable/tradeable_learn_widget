import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class AnimatedTextWidget extends StatelessWidget {
  final String title;
  final String prompt;
  final String logo;

  const AnimatedTextWidget(
      {super.key,
      required this.title,
      required this.prompt,
      required this.logo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            logo,
            package: 'tradeable_learn_widget/lib',
            height: 60,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: colors.borderColorSecondary),
                  borderRadius: BorderRadius.circular(10)),
              child: Markdown(
                data: prompt,
                shrinkWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
