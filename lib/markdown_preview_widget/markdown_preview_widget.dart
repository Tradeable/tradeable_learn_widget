import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/markdown_preview_widget/markdown_preview_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class MarkdownPreviewWidget extends StatefulWidget {
  final MarkdownPreviewModel model;
  final VoidCallback onNextClick;

  const MarkdownPreviewWidget(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<MarkdownPreviewWidget> createState() => _TextImagePreviewWidget();
}

class _TextImagePreviewWidget extends State<MarkdownPreviewWidget> {
  late MarkdownPreviewModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Markdown(
            shrinkWrap: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                    textAlign: WrapAlignment.center,
                    h1Padding: const EdgeInsets.only(top: 25, bottom: 15),
                    h3Padding: const EdgeInsets.only(top: 25, bottom: 15),
                    pPadding: const EdgeInsets.symmetric(vertical: 15),
                    h3: textStyles.largeBold.copyWith(fontSize: 28),
                    strong: textStyles.mediumBold,
                    p: textStyles.mediumNormal),
            data: model.content,
          ),
        ),
        ButtonWidget(color: colors.primary, btnContent: "Next", onTap: () {
          widget.onNextClick();
        })
      ]),
    );
  }
}
