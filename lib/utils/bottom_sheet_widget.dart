import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class BottomSheetWidget extends StatelessWidget {
  final bool isCorrect;
  final String explanationString;
  final VoidCallback onNextClick;

  const BottomSheetWidget(
      {super.key,
      required this.isCorrect,
      required this.explanationString,
      required this.onNextClick});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Image.asset(
                isCorrect
                    ? "assets/btmsheet_correct.png"
                    : "assets/btmsheet_incorrect.png",
                package: 'tradeable_learn_widget/lib',
                height: 120,
                fit: BoxFit.fitHeight,
              ),
            ),
            Text(isCorrect ? "Great!" : "Incorrect",
                style: textStyles.largeBold),
            Text("Explanation goes here", style: textStyles.smallNormal),
            const SizedBox(height: 20),
            ButtonWidget(
                color: colors.primary,
                btnContent: "Next",
                onTap: () {
                  Navigator.of(context).pop();
                  onNextClick();
                }),
          ],
        ),
      ),
    );
  }
}
