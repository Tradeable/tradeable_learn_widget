import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tradeable_learn_widget/fno_buy_story/option_intro_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ScenarioIntroWidget extends StatefulWidget {
  final OptionIntroModel model;
  final VoidCallback onNextClick;

  const ScenarioIntroWidget(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<ScenarioIntroWidget> createState() => _PageIntroState();
}

class _PageIntroState extends State<ScenarioIntroWidget> {
  late OptionIntroModel model;
  String userResponse = "";

  @override
  void initState() {
    model = widget.model;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onNextClick();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: <Widget>[
                    MarkdownBody(
                      data: model.content,
                      styleSheet: MarkdownStyleSheet.fromTheme(
                              Theme.of(context))
                          .copyWith(
                              h1Padding:
                                  const EdgeInsets.symmetric(vertical: 6),
                              pPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              textAlign: WrapAlignment.center,
                              h3: textStyles.largeBold.copyWith(fontSize: 28),
                              strong: textStyles.mediumBold,
                              p: textStyles.mediumNormal),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Divider(
                          thickness: 2,
                          endIndent: 0,
                          color: colors.axisColor,
                        )),
                    question(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color:
                  userResponse.isNotEmpty ? colors.primary : colors.secondary,
              btnContent: "Next",
              onTap: () {
                if (userResponse.isNotEmpty) {
                  widget.onNextClick();
                }
              }),
        ),
      ],
    );
  }

  Widget question() {
    final textStyles = Theme.of(context).customTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          model.question,
          style: textStyles.mediumNormal,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...model.options.asMap().entries.map((entry) {
              final option = entry.value.model;
              return optionBtn(
                src: option.imgSrc,
                txt: option.value,
                onTap: () {
                  setState(() {
                    userResponse = option.value;
                  });
                },
              );
            }),
          ],
        )
      ],
    );
  }

  Widget optionBtn(
      {required String src, required String txt, required VoidCallback onTap}) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
                color: userResponse == txt
                    ? colors.bullishColor
                    : Colors.transparent)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(src, width: 150, height: 110, fit: BoxFit.fill),
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              child: Text(
                txt,
                style: textStyles.mediumNormal,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
