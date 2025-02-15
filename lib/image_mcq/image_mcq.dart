import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/image_mcq/image_mcq_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ImageMcq extends StatefulWidget {
  final ImageMCQModel model;
  final VoidCallback onNextClick;

  const ImageMcq({super.key, required this.model, required this.onNextClick});

  @override
  State<ImageMcq> createState() => _ImageMcqState();
}

class _ImageMcqState extends State<ImageMcq> {
  late ImageMCQModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    QuestionWidget(question: model.question),
                    model.imgSrc!.isNotEmpty
                        ? Image.network(
                            model.imgSrc!,
                            height: 350,
                          )
                        : const SizedBox(height: 40),
                    renderOptions()
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: ButtonWidget(
                color: (model.userResponse ?? "").isNotEmpty
                    ? colors.primary
                    : colors.secondary,
                btnContent: "Next",
                onTap: () {
                  if ((model.userResponse ?? "").isNotEmpty) {
                    widget.onNextClick();
                  }
                }),
          ),
        ],
      );
    });
  }

  Widget renderOptions() {
    switch (model.state) {
      case ImageMcqState.loadUI:
        return buildOptions(correctResponse: null);
      case ImageMcqState.submitResponse:
        return buildOptions(correctResponse: model.correctResponse);
    }
  }

  Widget buildOptions({required String? correctResponse}) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      children: model.options
          .map(
            (e) => ImageMCQOption(
                option: e,
                correctResponse: correctResponse,
                onTap: (option) {
                  setState(() {
                    if (model.state == ImageMcqState.loadUI) {
                      setState(() {
                        model.userResponse = option;
                      });
                    }
                  });
                  submit();
                },
                selectedOption: model.userResponse),
          )
          .toList(),
    );
  }

  void submit() {
    setState(() {
      model.state = ImageMcqState.submitResponse;
      if (model.userResponse == model.correctResponse) {
        model.isCorrect = true;
      }
    });
    widget.onNextClick();
  }
}

class ImageMCQOption extends StatelessWidget {
  final String option;
  final Function(String option) onTap;
  final String? selectedOption;
  final String? correctResponse;
  final AutoSizeGroup? group;

  const ImageMCQOption(
      {super.key,
      required this.option,
      required this.onTap,
      required this.selectedOption,
      this.group,
      this.correctResponse});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;
    return InkWell(
      onTap: () {
        onTap(option);
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colors.borderColorSecondary),
            color: selectedOption == option
                ? correctResponse == option
                    ? colors.bullishColor
                    : colors.bearishColor
                : correctResponse == option
                    ? colors.bullishColor
                    : colors.buttonColor,
          ),
          child: AutoSizeText(option,
              maxLines: 2,
              minFontSize: 16,
              maxFontSize: 22,
              textAlign: TextAlign.center,
              style: textStyles.mediumNormal)),
    );
  }
}
