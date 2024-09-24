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
    final colors = Theme.of(context).customColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        renderQuestion(),
        Center(child: renderSingleSelectQuestion(model.userResponse ?? "")),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: ButtonWidget(
            color: colors.primary,
            btnContent: "Submit",
            onTap: () {
              submitResponse();
            },
          ),
        ),
      ],
    );
  }

  Widget renderQuestion() {
    final textStyles = Theme.of(context).customTextStyles;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        model.question,
        style: textStyles.smallNormal,
      ),
    );
  }

  Widget renderSingleSelectQuestion(String singleSelectAns) {
    final colors = Theme.of(context).customColors;

    Color candleColor =
        model.isBullish ? colors.bullishColor : colors.bearishColor;
    String correctResponse = "";
    switch (model.state) {
      case CandleBodySelectState.loadUI:
        correctResponse = "";
        break;
      case CandleBodySelectState.submitResponse:
        correctResponse = model.correctResponse;
        break;
    }
    return Container(
        margin: const EdgeInsets.only(top: 30),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CandleBodyPart(
              type: "high",
              height: model.wickHeight * 0.4,
              width: 10,
              color: candleColor,
              currentSelected: singleSelectAns,
              correctResponse: correctResponse,
              onTap: showAnimation,
            ),
            CandleBodyPart(
              type: "wick",
              height: model.wickHeight * 0.8,
              width: 10,
              color: candleColor,
              currentSelected: singleSelectAns,
              correctResponse: correctResponse,
              onTap: showAnimation,
            ),
            CandleBodyPart(
              type: model.isBullish ? "close" : "open",
              height: model.bodyHeight * 0.2,
              width: 40,
              color: candleColor,
              currentSelected: singleSelectAns,
              correctResponse: correctResponse,
              onTap: showAnimation,
            ),
            CandleBodyPart(
              type: "body",
              height: model.bodyHeight * 0.6,
              width: 40,
              color: candleColor,
              currentSelected: singleSelectAns,
              correctResponse: correctResponse,
              onTap: showAnimation,
            ),
            CandleBodyPart(
              type: model.isBullish ? "open" : "close",
              height: model.bodyHeight * 0.2,
              width: 40,
              color: candleColor,
              currentSelected: singleSelectAns,
              correctResponse: correctResponse,
              onTap: showAnimation,
            ),
            CandleBodyPart(
              type: "tail",
              height: model.tailHeight * 0.8,
              width: 10,
              color: candleColor,
              currentSelected: singleSelectAns,
              correctResponse: correctResponse,
              onTap: showAnimation,
            ),
            CandleBodyPart(
              type: "low",
              height: model.tailHeight * 0.4,
              width: 10,
              color: candleColor,
              currentSelected: singleSelectAns,
              correctResponse: correctResponse,
              onTap: showAnimation,
            ),
          ],
        ));
  }

  void showAnimation(String response) async {
    setState(() {
      model.userResponse = response;
    });
    if (model.correctResponse == model.userResponse) {
      setState(() {
        model.isCorrect = true;
      });
    }
  }

  void submitResponse() {
    final textStyles = Theme.of(context).customTextStyles;
    final colors = Theme.of(context).customColors;

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
          builder: (context) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 300,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: model.isCorrect
                                  ? colors.bullishColor.withOpacity(0.4)
                                  : colors.bearishColor.withOpacity(0.4))),
                      Text(model.isCorrect ? "Great!" : "Incorrect",
                          style: textStyles.mediumBold),
                      Text(
                        "Explanation comes here",
                        style: textStyles.smallNormal,
                      ),
                      const SizedBox(height: 10),
                      ButtonWidget(
                          color: colors.primary,
                          btnContent: "Next",
                          onTap: () {})
                    ],
                  ),
                ),
              ));
    }
  }
}

class CandleBodyPart extends StatelessWidget {
  final String type;
  final double height;
  final double width;
  final Color color;
  final String currentSelected;
  final String correctResponse;
  final Function(String) onTap;

  const CandleBodyPart(
      {super.key,
      required this.type,
      required this.height,
      required this.width,
      required this.color,
      required this.currentSelected,
      required this.correctResponse,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return InkWell(
      onTap: () {
        if (correctResponse == "") {
          onTap(type);
        }
      },
      child: Container(
        height: height,
        width: width,
        color: correctResponse == type
            ? colors.selectedItemColor
            : currentSelected == type
                ? colors.selectedItemColor.withOpacity(0.5)
                : color,
      ),
    );
  }
}

class CandlePartSelectQuestion {
  final String question;
  final String answer;

  CandlePartSelectQuestion(
      {required String type, required this.question, required this.answer});
}
