import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/ladder_widget/ladder_data_model.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class LadderContainer extends StatelessWidget {
  final List<LadderCell> phrases;
  final Widget Function(LadderCell) buildDragTarget;
  final BoxConstraints constraints;

  const LadderContainer({
    super.key,
    required this.phrases,
    required this.buildDragTarget,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    // double phraseHeight = constraints.maxHeight / (phrases.length + 1);
    double phraseWidth = constraints.maxWidth * 1.2;
    //
    // double totalPhraseHeight =
    //     phrases.length * phraseHeight + (phrases.length - 1) * 10;
    //
    // if (totalPhraseHeight > constraints.maxHeight) {
    //   phraseHeight =
    //       (constraints.maxHeight - (phrases.length - 1) * 20) / phrases.length;
    // }
    double phraseHeight = constraints.maxHeight / (phrases.length) - 20;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "Ladder\n(values)",
          textAlign: TextAlign.right,
          style: textStyles.smallBold.copyWith(fontSize: 12),
        ),
        Stack(
          children: [
            Column(
              children: [
                ...List.generate(
                  phrases.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    width: phraseWidth,
                    height: phraseHeight,
                    child: PhraseWidget(
                      phrase: phrases[index],
                      buildDragTarget: buildDragTarget,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            Positioned.fill(
              child: Row(
                children: [
                  ladderStick(context),
                  const Spacer(),
                  ladderStick(context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget ladderStick(BuildContext context) {
    return Container(
      width: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).customColors.cardColorSecondary,
        border: Border.all(
          color: Theme.of(context).customColors.borderColorSecondary,
          width: 4,
        ),
      ),
    );
  }
}

class PhraseWidget extends StatelessWidget {
  final LadderCell phrase;
  final Widget Function(LadderCell) buildDragTarget;

  const PhraseWidget({
    super.key,
    required this.phrase,
    required this.buildDragTarget,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return phrase.model.isQuestion
        ? buildDragTarget(phrase)
        : Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colors.borderColorSecondary, width: 3),
            ),
            child: Center(
              child: Text(
                phrase.model.value,
                textAlign: TextAlign.center,
                style: textStyles.smallBold,
              ),
            ),
          );
  }
}
