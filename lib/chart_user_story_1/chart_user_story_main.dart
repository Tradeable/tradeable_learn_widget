import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/chart_user_story_1/chart_user_story_model.dart';
import 'package:tradeable_learn_widget/mutual_funds/exit_fees_calculator/animated_text_widget.dart';

class ChartUserStoryMain extends StatefulWidget {
  final ChartUserStoryModel model;

  const ChartUserStoryMain({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _ChartUserStoryMainState();
}

class _ChartUserStoryMainState extends State<ChartUserStoryMain> {
  int currentStepIndex = 0;
  final Map<String, dynamic> userResponses = {};

  WorkflowStep get currentStep => widget.model.steps[currentStepIndex];

  void _validateTextInput(String value) {
    String trimmedValue = value.trim();

    if (trimmedValue == currentStep.validationCriteria) {
      _onSuccess();
    } else {
      _onFailure();
    }
  }

  void _onSuccess() {
    userResponses[currentStep.stepId] = currentStep.validationCriteria;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(currentStep.successMessage ?? "Correct!")),
    );
    setState(() {
      currentStepIndex++;
    });
  }

  void _onFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(currentStep.failureMessage ?? "Try again.")),
    );
  }

  Widget _buildStepContent(WorkflowStep step) {
    switch (step.widget) {
      case "AnimatedText":
        return AnimatedText(
          text: step.prompt,
          onAnimationComplete: () {},
        );
      case "Container":
        return Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Center(child: Text(step.prompt)),
        );
      case "TextInput":
        return Column(
          children: [
            Text(step.prompt),
            TextField(
              onSubmitted: _validateTextInput,
              decoration: InputDecoration(
                hintText: 'Enter your answer',
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.model.steps.sublist(0, currentStepIndex + 1).map((step) {
          return _buildStepContent(step);
        }),
        if (currentStep.widget != "TextInput" && currentStep.nextStep != null)
          ElevatedButton(
            onPressed: () {
              if (currentStep.nextStep != null) {
                setState(() {
                  currentStepIndex++;
                });
              }
            },
            child: const Text("Next"),
          ),
      ],
    );
  }
}
