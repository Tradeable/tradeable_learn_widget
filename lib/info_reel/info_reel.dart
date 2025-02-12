import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/info_reel/info_reel_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class InfoReel extends StatefulWidget {
  final InfoReelModel model;
  final VoidCallback onNextClick;

  const InfoReel({super.key, required this.model, required this.onNextClick});

  @override
  State<InfoReel> createState() => _InfoReelState();
}

class _InfoReelState extends State<InfoReel> {
  late InfoReelModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 70),
            child: Markdown(
                shrinkWrap: false,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                        h3: textStyles.largeBold.copyWith(fontSize: 28),
                        strong: textStyles.mediumBold,
                        p: textStyles.mediumNormal),
                //controller: widget.scrollController,
                data: model.markdownString),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: ButtonWidget(
                color: colors.primary,
                btnContent: "Next",
                onTap: () {
                  widget.onNextClick();
                }),
          ),
        ),
      ],
    );
  }
}
