import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class PlainTextWithBorder extends StatelessWidget {
  final String title;
  final String prompt;

  const PlainTextWithBorder(
      {super.key, required this.title, required this.prompt});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: colors.borderColorSecondary),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 14, top: 10),
                      child: Text(title,
                          style: textStyles.mediumNormal
                              .copyWith(color: colors.axisColor)),
                    )
                  : const SizedBox(height: 10),
              title.isNotEmpty
                  ? const SizedBox(height: 10)
                  : const SizedBox.shrink(),
              Markdown(
                data: prompt,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 14, bottom: 10, right: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
