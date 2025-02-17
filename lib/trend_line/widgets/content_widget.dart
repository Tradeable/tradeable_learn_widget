import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ContentWidget extends StatelessWidget {
  final String content;
  final VoidCallback moveNext;

  const ContentWidget(
      {super.key, required this.content, required this.moveNext});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Column(
        children: [
          MarkdownBody(
            data: content,
            shrinkWrap: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                    textAlign: WrapAlignment.center,
                    h3: textStyles.largeBold,
                    strong: textStyles.mediumBold,
                    p: textStyles.mediumNormal.copyWith(
                        fontSize: 18, backgroundColor: Colors.transparent)),
          ),
          const SizedBox(height: 20),
          ButtonWidget(
              color: colors.primary,
              btnContent: 'Next',
              onTap: () {
                moveNext();
              })
        ],
      ),
    );
  }
}
