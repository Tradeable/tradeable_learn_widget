import 'package:carousel_slider_plus/carousel_slider_plus.dart';
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
  final Map<String, TextEditingController> _controllers = {};
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  WorkflowStep get currentStep => widget.model.steps[currentStepIndex];

  bool get isLastStep => currentStepIndex == widget.model.steps.length - 1;

  @override
  void initState() {
    super.initState();
    _handleStepTransition();
    for (var step in widget.model.steps) {
      if (step.widget == "TextInput") {
        _controllers[step.stepId] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _handleStepTransition() {
    while (currentStep.skippable && currentStep.nextStep != null) {
      setState(() {
        currentStepIndex++;
      });
    }
  }

  void _validateCurrentInput() {
    final currentController = _controllers[currentStep.stepId];
    if (currentController == null) return;

    final trimmedValue = currentController.text.trim();
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
    userResponses[currentStep.stepId] =
        _controllers[currentStep.stepId]!.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(currentStep.successMessage ?? "Correct!")),
    );
    if (!isLastStep) {
      setState(() {
        currentStepIndex++;
      });
      _handleStepTransition();
      if (currentStep.widget == "TextInput") {
        _carouselController.animateToPage(currentStepIndex);
      }
    }
  }

  void _onFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(currentStep.failureMessage ?? "Try again."),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildCarouselCard(WorkflowStep step) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              step.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              step.prompt,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controllers[step.stepId],
              decoration: InputDecoration(
                hintText: 'Enter your answer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(WorkflowStep step) {
    switch (step.widget) {
      case "AnimatedText":
        return AnimatedText(
          text: step.prompt,
          onAnimationComplete: () {
            if (step.nextStep != null) {
              setState(() {
                currentStepIndex++;
              });
              _handleStepTransition();
            }
          },
        );

      case "Container":
        return Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Center(child: Text(step.prompt)),
        );

      case "CarouselSlider":
        final textInputSteps = widget.model.steps
            .where((s) => s.widget == "CarousalItem")
            .toList();

        final currentTextInputIndex =
            textInputSteps.indexWhere((s) => s.stepId == step.stepId);

        return CarouselSlider(
          controller: _carouselController,
          options: CarouselOptions(
            height: 300,
            viewportFraction: 0.85,
            initialPage: currentTextInputIndex,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              final selectedStep = textInputSteps[index];
              setState(() {
                currentStepIndex = widget.model.steps
                    .indexWhere((s) => s.stepId == selectedStep.stepId);
              });
            },
          ),
          items: textInputSteps.map((step) => _buildStepContent(step)).toList(),

          // items:
          //     textInputSteps.map((step) => _buildCarouselCard(step)).toList(),
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
                    .map((step) => _buildStepContent(step)),
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
                  ? _validateCurrentInput
                  : () {
                      if (currentStep.nextStep != null) {
                        setState(() {
                          currentStepIndex++;
                        });
                        _handleStepTransition();
                      }
                    },
            ),
          ),
      ],
    );
  }
}
