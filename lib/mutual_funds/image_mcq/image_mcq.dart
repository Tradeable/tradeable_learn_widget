import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/mutual_funds/image_mcq/image_mcq_model.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ImageMcq extends StatefulWidget {
  final ImageMCQModel model;

  const ImageMcq({super.key, required this.model});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        model.imgSrc!.isNotEmpty
            ? Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(model.imgSrc!,
                        height: 350, fit: BoxFit.cover)),
              )
            : const SizedBox(height: 40),
        const SizedBox(height: 20),
        renderQuestion(),
        renderOptions(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color: colors.primary,
              btnContent: "Submit",
              onTap: () {
                submit();
              }),
        ),
      ],
    );
  }

  Widget renderQuestion() {
    final textStyles = Theme.of(context).customTextStyles;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(model.question,
            textAlign: TextAlign.center, style: textStyles.mediumNormal));
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
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2),
      itemCount: model.options.length,
      itemBuilder: (context, index) {
        final option = model.options[index];
        return QuizOptions(
          option: option,
          correctResponse: correctResponse,
          onTap: (option) {
            setState(() {
              if (model.state == ImageMcqState.loadUI) {
                model.userResponse = option;
              }
            });
          },
          selectedOption: model.userResponse,
        );
      },
    );
  }

  void submit() {
    setState(() {
      model.state = ImageMcqState.submitResponse;
      if (model.userResponse == model.correctResponse) {
        model.isCorrect = true;
      }
    });
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => BottomSheetWidget(
            isCorrect: model.isCorrect,
            explanationString: "Explanation goes here"));
  }
}

class QuizOptions extends StatelessWidget {
  final String option;
  final Function(String option) onTap;
  final String? selectedOption;
  final String? correctResponse;

  const QuizOptions({
    super.key,
    required this.option,
    required this.onTap,
    required this.selectedOption,
    this.correctResponse,
  });

  @override
  Widget build(BuildContext context) {
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
          color: selectedOption == option
              ? colors.selectedItemColor
              : colors.cardColorSecondary,
        ),
        child: Center(
          child: AutoSizeText(option,
              maxLines: 2,
              minFontSize: 16,
              maxFontSize: 22,
              textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
