import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ContentWidget extends StatelessWidget {
  final String content;

  const ContentWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MarkdownBody(
        data: content,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            textAlign: WrapAlignment.center,
            h3: textStyles.largeBold,
            strong: textStyles.mediumBold,
            p: textStyles.mediumNormal
                .copyWith(fontSize: 18, backgroundColor: Colors.transparent)),
      ),
    );
  }
}
