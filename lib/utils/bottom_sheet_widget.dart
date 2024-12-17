import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/explanation_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class BottomSheetWidget extends StatelessWidget {
  final ExplanationV1? model;
  final bool isCorrect;
  final VoidCallback onNextClick;

  const BottomSheetWidget({
    super.key,
    required this.model,
    required this.isCorrect,
    required this.onNextClick,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    final explainer = model?.getExplanation(isCorrect).first;
    print(model);
    print(explainer);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBasicBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: explainer?.imageUrl != null
                  ? (explainer!.imageUrl!.startsWith("http")
                      ? Image.network(
                          explainer.imageUrl!,
                          height: 120,
                          fit: BoxFit.fitHeight,
                        )
                      : Image.asset(
                          explainer.imageUrl!,
                          package: 'tradeable_learn_widget/lib',
                          height: 120,
                          fit: BoxFit.fitHeight,
                        ))
                  : const SizedBox.shrink(),
            ),
            Text(
              explainer?.title ?? '',
              style: textStyles.largeBold,
            ),
            const SizedBox(height: 8),
            Text(
              explainer?.data ?? '',
              style: textStyles.smallNormal,
            ),
            const SizedBox(height: 20),
            ButtonWidget(
              color: colors.primary,
              btnContent: "Next",
              onTap: () {
                Navigator.of(context).pop();
                onNextClick();
              },
            ),
          ],
        ),
      ),
    );
  }
}
