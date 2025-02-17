import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tradeable_learn_widget/candle_formation/candle_formation_model.dart';
import 'package:tradeable_learn_widget/candle_formation/widgets/body_part_widget.dart';
import 'package:tradeable_learn_widget/candle_formation/widgets/option_widget.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CandleFormation extends StatefulWidget {
  final CandleFormationModel model;
  final VoidCallback onNextClick;

  const CandleFormation(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<CandleFormation> createState() => _CandlePartMatchLinkState();
}

class _CandlePartMatchLinkState extends State<CandleFormation> {
  late CandleFormationModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...renderCandle(model.selectedOptions, model.candleColor)
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.4,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: QuestionWidget(question: model.question)),
                  ),
                  SizedBox(
                      height: constraints.maxHeight / 4,
                      child: buildOptions(model.state)),
                  const Spacer(),
                  renderSubmitBtn()
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<CandleFormationPart> renderCandle(
      List<String> selectedOptions, Color candleColor) {
    List<CandleFormationPart> candleOptions = [];
    for (String option in selectedOptions) {
      switch (option) {
        case "long_body_green":
        case "long_body_red":
        case "long_body":
          candleOptions.add(CandleFormationPart(
              type: "body", height: 140, width: 60, color: candleColor));
          break;
        case "short_body_green":
        case "short_body_red":
        case "short_body":
          candleOptions.add(CandleFormationPart(
              type: "body", height: 80, width: 60, color: candleColor));
          break;
        case "prominent_wick":
        case "long_wick":
          candleOptions.add(CandleFormationPart(
              type: "wick", height: 100, width: 10, color: candleColor));
          break;
        case "small_tail/no_tail":
        case "small_tail":
        case "no_tail":
        case "short_tail":
          candleOptions.add(CandleFormationPart(
              type: "tail", height: 50, width: 10, color: candleColor));
          break;
        case "prominent_tail":
        case "long_tail":
          candleOptions.add(CandleFormationPart(
              type: "tail", height: 100, width: 10, color: candleColor));
          break;
        case "short_wick":
        case "small_wick/no_wick":
        case "small_wick":
        case "no_wick":
          candleOptions.add(CandleFormationPart(
            type: "wick",
            height: 50,
            width: 10,
            color: candleColor,
          ));
          break;
        default:
          selectedOptions.add(option);
          break;
      }
    }

    return candleOptions;
  }

  Widget renderSubmitBtn() {
    final colors = Theme.of(context).customColors;

    switch (model.state) {
      case CandleFormationState.loadUI:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color: model.selectedOptions.length < 3
                  ? colors.secondary
                  : colors.primary,
              btnContent: "Submit",
              onTap: () {
                if (model.selectedOptions.length >= 3) {
                  submitResponse(model.selectedOptions);
                }
              }),
        );
      case CandleFormationState.submitResponse:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: ButtonWidget(
              color: colors.primary,
              btnContent: "Next",
              onTap: () {
                widget.onNextClick();
              }),
        );
    }
  }

  void submitResponse(List<String> response) {
    setState(() {
      model.userResponse = response;
      model.state = CandleFormationState.submitResponse;
      if (model.incorrectResponse!.isEmpty) {
        if (model.userResponse!.length == model.options.length) {
          setState(() {
            model.isCorrect = true;
          });
        } else {
          setState(() {
            model.isCorrect = false;
          });
        }
      } else {
        setState(() {
          model.isCorrect = !model.incorrectResponse!
              .map((x) => x.toLowerCase())
              .toList()
              .any((element) =>
                  model.userResponse!.contains(element.toLowerCase()));
        });
      }
    });
  }

  Widget buildOptions(CandleFormationState state) {
    return GridView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 4,
        childAspectRatio: model.options.length < 4 ? 0.4 : 1 / 2,
        // mainAxisExtent: 150
      ),
      padding: const EdgeInsets.all(10),
      itemCount: model.options.length,
      itemBuilder: (BuildContext context, int index) {
        final option = model.options[index];
        return QuizQuestionOption(
          state: state,
          option: option,
          incorrectResponse: model.incorrectResponse,
          onTap: (option) {
            setState(() {
              model.toggleOptionSelection(model.options[index].optionId);
            });
          },
          selectedOption: option.optionId,
          selectedOptions: model.selectedOptions,
        );
      },
    );
  }

  Widget bottomSheetResponse(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
            model.isCorrect
                ? "assets/exercise_won.json"
                : "assets/exercise_failed.json",
            height: 150),
        Text(
          model.isCorrect
              ? " Great!\nYou got all 3 parts of the candle right"
              : "Oops, ${model.incorrectResponse.toString().replaceAll(RegExp(r'[^A-Za-z0-9\s]'), ' ')} is not a part of the ${model.question.split(" ").skip(2).join(" ")}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.transparent),
                color: const Color(0xFF252A34),
              ),
              child: const Center(
                child: Text("Okay",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              )),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  void showErrorMessage() async {
    Dialog dialog = Dialog(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(10),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                "You need to select 3 parts",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
