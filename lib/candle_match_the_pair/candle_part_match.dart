import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/candle_match_the_pair/match_the_pair_model.dart';
import 'package:tradeable_learn_widget/candle_match_the_pair/widgets/match_painter.dart';
import 'package:tradeable_learn_widget/candle_match_the_pair/widgets/option_container_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CandlePartMatchLink extends StatefulWidget {
  final CandleMatchThePairModel model;

  const CandlePartMatchLink({super.key, required this.model});

  @override
  State<CandlePartMatchLink> createState() => _CandlePartMatchLinkState();
}

class _CandlePartMatchLinkState extends State<CandlePartMatchLink> {
  late CandleMatchThePairModel model;
  List<Option>? options;
  double candleVerticalPadding = 20;
  double canvasPadding = 20;
  double candleWidth = 20;
  double shadowWidth = 2;
  double optionContainerWidth = 85;
  double optionContainerHeight = 45;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyles = theme.customTextStyles;
    final colors = theme.customColors;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              "Drag and drop",
              style: textStyles.mediumNormal,
            ),
          ),
          const SizedBox(height: 10),
          renderProblem(constraints),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: ButtonWidget(
                color: model.state == CandlePartMatchLinkState.loadUI
                    ? colors.secondary
                    : colors.primary,
                btnContent: "Submit",
                onTap: () {
                  submitResponse();
                }),
          ),
        ],
      );
    });
  }

  Widget renderProblem(BoxConstraints constraints) {
    double stackHeight = constraints.maxHeight * 0.75;
    double canvasHeight = constraints.maxHeight * 0.6;

    double candleAreaHeight =
        canvasHeight - 2 * (candleVerticalPadding + canvasPadding);
    double spaceToLeaveAtTop = canvasPadding + candleVerticalPadding;

    if (options != null && model.state == CandlePartMatchLinkState.loadUI) {
      int placedCount = options!.fold<int>(
        0,
        (previousValue, option) => option.offset != option.originalOffset
            ? previousValue + 1
            : previousValue,
      );
      if (placedCount == model.pairFor.length) {
        showAnimation();
      }
    }

    options = options ??
        [
          Option(
              option: "High",
              offset: Offset(20, stackHeight - 100),
              correctOffset: Offset(
                  canvasPadding,
                  spaceToLeaveAtTop +
                      (candleAreaHeight / 8) * 0 -
                      optionContainerHeight / 2)),
          Option(
              option: "Open",
              offset: Offset(110, stackHeight - 100),
              correctOffset: Offset(
                  canvasPadding,
                  spaceToLeaveAtTop +
                      (candleAreaHeight / 8) * (model.isBullish ? 6 : 2) -
                      optionContainerHeight / 2)),
          Option(
              option: "Close",
              offset: Offset(200, stackHeight - 100),
              correctOffset: Offset(
                  canvasPadding,
                  spaceToLeaveAtTop +
                      (candleAreaHeight / 8) * (model.isBullish ? 2 : 6) -
                      optionContainerHeight / 2)),
          Option(
              option: "Low",
              offset: Offset(20, stackHeight - 50),
              correctOffset: Offset(
                  canvasPadding,
                  spaceToLeaveAtTop +
                      (candleAreaHeight / 8) * 8 -
                      optionContainerHeight / 2)),
          Option(
              option: "Body",
              offset: Offset(110, stackHeight - 50),
              correctOffset: Offset(
                  constraints.maxWidth - canvasPadding - optionContainerWidth,
                  spaceToLeaveAtTop +
                      (candleAreaHeight / 8) * 4 -
                      optionContainerHeight / 2)),
          Option(
              option: "Wick",
              offset: Offset(200, stackHeight - 50),
              correctOffset: Offset(
                  constraints.maxWidth - canvasPadding - optionContainerWidth,
                  spaceToLeaveAtTop +
                      (candleAreaHeight / 8) * 1 -
                      optionContainerHeight / 2)),
          Option(
              option: "Tail",
              offset: Offset(290, stackHeight - 50),
              correctOffset: Offset(
                  constraints.maxWidth - canvasPadding - optionContainerWidth,
                  spaceToLeaveAtTop +
                      (candleAreaHeight / 8) * 7 -
                      optionContainerHeight / 2)),
        ];

    return SizedBox(
      width: constraints.maxWidth,
      height: stackHeight,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          SizedBox(
              width: constraints.maxWidth,
              height: canvasHeight,
              child: CustomPaint(
                painter: CandlePartMatchPainter(
                    optionHolderHeight: optionContainerHeight,
                    optionHolderWidth: optionContainerWidth,
                    candleVerticalPadding: candleVerticalPadding,
                    candleWidth: candleWidth,
                    shadowWidth: shadowWidth,
                    isBullish: model.isBullish,
                    canvasHeight: canvasHeight,
                    canvasPadding: canvasPadding,
                    pairFor: model.pairFor,
                    theme: Theme.of(context)),
              )),
          ...options!.map((e) => OptionContainer(
              width: optionContainerWidth,
              height: optionContainerHeight,
              option: e,
              snapOffests: options!.map((e) => e.correctOffset).toList(),
              onUpdate: (option) {
                setState(() {
                  e = option;
                });
              })),
        ],
      ),
    );
  }

  void showAnimation() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((c) {
      setState(() {
        model.state = CandlePartMatchLinkState.submitResponse;
      });
    });
  }

  void submitResponse() {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;
    if (options != null && model.state == CandlePartMatchLinkState.loadUI) {
      int correctCount = options!.fold<int>(
          0,
          (previousValue, element) =>
              element.isCorrect ? previousValue + 1 : previousValue);
      if (correctCount == model.pairFor.length) {
        setState(() {
          model.isCorrect = true;
        });
      }
    }
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: Image.asset(
                        model.isCorrect
                            ? "assets/btmsheet_correct.png"
                            : "assets/btmsheet_incorrect.png",
                        package: 'tradeable_learn_widget/lib',
                        height: 120,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Text(model.isCorrect ? "Great!" : "Incorrect",
                        style: textStyles.largeBold),
                    Text("Explanation goes here",
                        style: textStyles.smallNormal),
                    const SizedBox(height: 20),
                    ButtonWidget(
                        color: colors.primary,
                        btnContent: "Next",
                        onTap: () {}),
                  ],
                ),
              ),
            ));
  }
}
