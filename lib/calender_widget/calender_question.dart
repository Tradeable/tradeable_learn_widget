import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:tradeable_learn_widget/calender_widget/calender_model.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CalenderQuestion extends StatefulWidget {
  final CalenderQuestionModel model;
  final VoidCallback onNextClick;

  const CalenderQuestion(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<CalenderQuestion> createState() => _CalenderQuestionState();
}

class _CalenderQuestionState extends State<CalenderQuestion> {
  List<DateTime?> selectedDates = [];
  List<DateTime> correctResponseDates = [];
  late CalenderQuestionModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuestionWidget(question: model.question),
            const SizedBox(height: 20),
            HeatMap(
              showColorTip: false,
              showText: true,
              textColor: colors.axisColor,
              borderRadius: (10),
              size: 40,
              fontSize: 20,
              margin: const EdgeInsets.all(8),
              colorMode: ColorMode.color,
              startDate: DateTime.parse(model.initialDate),
              endDate: DateTime.parse(model.endDate),
              datasets: {
                for (var date in selectedDates)
                  if (date != null) date: 0,
                for (var date in correctResponseDates) date: 1,
              },
              colorsets: {
                0: colors.selectedItemColor,
                1: colors.bullishColor,
              },
              onClick: (value) {
                setState(() {
                  if (selectedDates.contains(value)) {
                    selectedDates.remove(value);
                  } else {
                    selectedDates.add(value);
                  }
                });
                if (selectedDates.length == model.correctResponses.length) {
                  setState(() {
                    correctResponseDates = model.correctResponses.map((date) {
                      return DateTime.parse(date);
                    }).toList();
                    model.isCorrect = List.from(selectedDates)
                        .every((date) => correctResponseDates.contains(date));
                  });
                }
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: ButtonWidget(
                color: colors.primary,
                btnContent: "Submit",
                onTap: () {
                  widget.onNextClick();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
