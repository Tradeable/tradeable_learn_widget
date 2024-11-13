import 'package:dart_eval/stdlib/core.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/chart_user_story_1/chart_user_story_model.dart';
import 'package:tradeable_learn_widget/mutual_funds/exit_fees_calculator/animated_text_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:dart_eval/dart_eval.dart';

class ChartUserStoryMain extends StatefulWidget {
  final ChartUserStoryModel model;

  const ChartUserStoryMain({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _ChartUserStoryMainState();
}

class _ChartUserStoryMainState extends State<ChartUserStoryMain> {
  int currentStepIndex = 0;
  final Map<String, dynamic> userResponses = {};
  final TextEditingController _textController = TextEditingController();

  WorkflowStep get currentStep => widget.model.steps[currentStepIndex];

  bool get isLastStep => currentStepIndex == widget.model.steps.length - 1;

  @override
  void initState() {
    super.initState();
    _handleStepTransition();
  }

  void _handleStepTransition() {
    while (currentStep.skippable && currentStep.nextStep != null) {
      setState(() {
        currentStepIndex++;
      });
    }
  }

  void _moveToNextStep() {
    if (currentStep.nextStep != null) {
      setState(() {
        currentStepIndex++;
        _textController.clear();
      });
      _handleStepTransition();
    }
  }

  void _validateTextInput() {
    final trimmedValue = _textController.text.trim();
    final validationCode = currentStep.validationCriteria;

    try {
      final result = eval(
        '''
      bool validate(String input) {
        return $validationCode;
      }
      ''',
        function: 'validate',
        args: [$String(trimmedValue)],
      );

      if (result == true) {
        _onSuccess();
      } else {
        _onFailure();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Validation error: $e")),
      );
    }
  }

  void _onSuccess() {
    userResponses[currentStep.stepId] = _textController.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(currentStep.successMessage ?? "Correct!")),
    );
    _moveToNextStep();
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
          onAnimationComplete: _moveToNextStep,
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
              controller: _textController,
              decoration: const InputDecoration(
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
    final colors = Theme.of(context).customColors;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...widget.model.steps
                    .sublist(0, currentStepIndex + 1)
                    .map((step) {
                  return _buildStepContent(step);
                }),
              ],
            ),
          ),
        ),
        if (!currentStep.skippable || isLastStep)
          Container(
            height: 60,
            padding: const EdgeInsets.all(10),
            child: ButtonWidget(
              color: colors.primary,
              btnContent: isLastStep ? "Submit" : "Next",
              onTap: currentStep.widget == "TextInput"
                  ? _validateTextInput
                  : _moveToNextStep,
            ),
          ),
      ],
    );
  }
}
