import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/candle_body_select/candle_body_select_model.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CandleBodySelect extends StatefulWidget {
  final CandlePartSelectModel model;

  const CandleBodySelect({super.key, required this.model});

  @override
  State<CandleBodySelect> createState() => _CandleBodySelectState();
}

class _CandleBodySelectState extends State<CandleBodySelect> {
  late CandlePartSelectModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderQuestion(theme),
        Center(
            child:
                renderSingleSelectQuestion(model.userResponse ?? "", colors)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: ButtonWidget(
            color: colors.primary,
            btnContent: "Submit",
            onTap: submitResponse,
          ),
        ),
      ],
    );
  }

  Widget renderQuestion(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        model.question,
        style: theme.customTextStyles.smallNormal,
      ),
    );
  }

  Widget renderSingleSelectQuestion(
      String selectedAnswer, CustomColors colors) {
    final candleColor =
        model.isBullish ? colors.bullishColor : colors.bearishColor;
    final correctResponse = model.state == CandleBodySelectState.submitResponse
        ? model.correctResponse
        : "";

    return Container(
      margin: const EdgeInsets.only(top: 30),
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var part in candleParts())
            CandleBodyPart(
              type: part['type'],
              height: part['height'],
              width: part['width'],
              color: candleColor,
              currentSelected: selectedAnswer,
              correctResponse: correctResponse,
              onTap: showAnimation,
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> candleParts() {
    return [
      {"type": "high", "height": model.wickHeight * 0.4, "width": 10},
      {"type": "wick", "height": model.wickHeight * 0.8, "width": 10},
      {
        "type": model.isBullish ? "close" : "open",
        "height": model.bodyHeight * 0.2,
        "width": 40
      },
      {"type": "body", "height": model.bodyHeight * 0.6, "width": 40},
      {
        "type": model.isBullish ? "open" : "close",
        "height": model.bodyHeight * 0.2,
        "width": 40
      },
      {"type": "tail", "height": model.tailHeight * 0.8, "width": 10},
      {"type": "low", "height": model.tailHeight * 0.4, "width": 10},
    ];
  }

  void showAnimation(String response) {
    setState(() {
      model.userResponse = response;
      if (model.correctResponse == response) {
        model.isCorrect = true;
      }
    });
  }

  void submitResponse() {
    if ((model.userResponse ?? "").isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Tap on the candle to proceed"),
      ));
    } else {
      setState(() {
        model.state = CandleBodySelectState.submitResponse;
      });
      showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) => buildBottomSheet(),
      );
    }
  }

  Widget buildBottomSheet() {
    final theme = Theme.of(context);
    final colors = theme.customColors;
    final candleColor =
        model.isBullish ? colors.bullishColor : colors.bearishColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: model.isCorrect
                        ? colors.bullishColor.withOpacity(0.4)
                        : colors.bearishColor.withOpacity(0.4),
                  ),
                ),
                SizedBox(
                    height: 300, child: buildCandleModel(colors, candleColor)),
              ],
            ),
            Text(model.isCorrect ? "Great!" : "Incorrect",
                style: theme.customTextStyles.mediumBold),
            Text("Explanation comes here",
                style: theme.customTextStyles.smallNormal),
            const SizedBox(height: 10),
            ButtonWidget(
              color: colors.primary,
              btnContent: "Next",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCandleModel(CustomColors colors, Color candleColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: candleParts()
          .map((part) => Flexible(
                child: CandleBodyPart(
                  type: part['type'],
                  height: part['height'],
                  width: part['width'],
                  color: candleColor,
                  currentSelected: "",
                  correctResponse: model.correctResponse,
                  onTap: showAnimation,
                ),
              ))
          .toList(),
    );
  }
}

class CandleBodyPart extends StatelessWidget {
  final String type;
  final double height;
  final int width;
  final Color color;
  final String currentSelected;
  final String correctResponse;
  final Function(String) onTap;

  const CandleBodyPart({
    super.key,
    required this.type,
    required this.height,
    required this.width,
    required this.color,
    required this.currentSelected,
    required this.correctResponse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final isSelected = currentSelected == type;

    return InkWell(
      onTap: correctResponse.isEmpty ? () => onTap(type) : null,
      child: Container(
        height: height,
        width: width.toDouble(),
        color: correctResponse == type
            ? colors.selectedItemColor
            : isSelected
                ? colors.selectedItemColor.withOpacity(0.5)
                : color,
      ),
    );
  }
}
