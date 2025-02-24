import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/candle_body_select/candle_body_select_model.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/bottom_sheet_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CandleBodySelect extends StatefulWidget {
  final CandlePartSelectModel model;
  final VoidCallback onNextClick;

  const CandleBodySelect(
      {super.key, required this.model, required this.onNextClick});

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
        const SizedBox(height: 10),
        QuestionWidget(question: model.question),
        Center(
            child:
                renderSingleSelectQuestion(model.userResponse ?? "", colors)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
            color: (model.userResponse ?? "").isEmpty
                ? colors.secondary
                : colors.primary,
            btnContent: "Submit",
            onTap: submitResponse,
          ),
        ),
      ],
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
    if ((model.userResponse ?? "").isNotEmpty) {
      setState(() {
        model.state = CandleBodySelectState.submitResponse;
      });
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          builder: (context) => BottomSheetWidget(
              isCorrect: model.isCorrect,
              model: model.explanationV1,
              onNextClick: () {
                widget.onNextClick();
              }));
    }
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
