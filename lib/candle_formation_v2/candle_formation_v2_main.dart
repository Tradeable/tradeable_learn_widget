import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/candle_formation_v2/candle_formation_v2_model.dart';
import 'package:tradeable_learn_widget/utils/question_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CandleFormationV2Main extends StatefulWidget {
  final CandleFormationV2Model model;
  final VoidCallback onNextClick;

  const CandleFormationV2Main(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<CandleFormationV2Main> createState() => _CandleFormationV2MainState();
}

class _CandleFormationV2MainState extends State<CandleFormationV2Main>
    with SingleTickerProviderStateMixin {
  late CandleFormationV2Model model;
  late AnimationController _animationController;
  late Animation<Offset> _wickAnimation;
  late Animation<Offset> _tailAnimation;

  late PageController _wickController;
  late PageController _bodyController;
  late PageController _tailController;

  @override
  void initState() {
    model = widget.model;
    final random = Random();

    model.selectedWick =
        model.wickOptions[random.nextInt(model.wickOptions.length - 2) + 1];
    model.selectedBody =
        model.bodyOptions[random.nextInt(model.bodyOptions.length - 2) + 1];
    model.selectedTail =
        model.tailOptions[random.nextInt(model.tailOptions.length - 2) + 1];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _wickAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(_animationController);

    _tailAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(_animationController);

    _wickController = PageController(
      initialPage: model.wickOptions.indexOf(model.selectedWick),
      viewportFraction: 0.3,
    );
    _bodyController = PageController(
      initialPage: model.bodyOptions.indexOf(model.selectedBody),
      viewportFraction: 0.3,
    );
    _tailController = PageController(
      initialPage: model.tailOptions.indexOf(model.selectedTail),
      viewportFraction: 0.3,
    );
    super.initState();
  }

  void submit() {
    setState(() {
      model.state = CandleFormationState.submitted;
    });
    _animationController.forward().then((_) {
      if (listEquals(model.correctOptions,
          [model.selectedWick, model.selectedBody, model.selectedTail])) {
        setState(() {
          model.isIncorrect = false;
        });
      } else {
        setState(() {
          model.isIncorrect = true;
        });
        Future.delayed(const Duration(seconds: 1)).then((a) {
          _animationController.reverse().then((_) {
            setState(() {
              model.isIncorrect = false;
              model.state = CandleFormationState.selecting;
            });
          });
        });
      }
    });
  }

  void scrollToCorrectAnswers() {
    final wickIndex = model.wickOptions.indexOf(model.correctOptions[0]);
    final bodyIndex = model.bodyOptions.indexOf(model.correctOptions[1]);
    final tailIndex = model.tailOptions.indexOf(model.correctOptions[2]);

    _wickController.animateToPage(wickIndex,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    _bodyController.animateToPage(bodyIndex,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    _tailController.animateToPage(tailIndex,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final containerHeight = constraints.maxHeight * 0.8 / 3 - 40;
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: QuestionWidget(question: model.question)),
                      IconButton(
                          onPressed: () {
                            scrollToCorrectAnswers();
                          },
                          icon: const Icon(Icons.info_outline))
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildScrollableContainer(
                        'wick',
                        containerHeight,
                        model.selectedWick,
                        model.wickOptions,
                        (option) => setState(() => model.selectedWick = option),
                      ),
                      buildScrollableContainer(
                        'body',
                        containerHeight,
                        model.selectedBody,
                        model.bodyOptions,
                        (option) => setState(() => model.selectedBody = option),
                      ),
                      buildScrollableContainer(
                        'tail',
                        containerHeight,
                        model.selectedTail,
                        model.tailOptions,
                        (option) => setState(() => model.selectedTail = option),
                      ),
                    ],
                  ),
                ),
                model.state == CandleFormationState.selecting
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        child: ButtonWidget(
                            color: colors.primary,
                            btnContent: "Submit",
                            onTap: submit),
                      )
                    : const SizedBox(height: 50),
              ],
            ),
            if (model.state == CandleFormationState.submitted)
              Container(
                color: Colors.transparent,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: model.isIncorrect
                        ? colors.bearishColor.withOpacity(0.2)
                        : Colors.black.withOpacity(0.8),
                    child: buildResultContainer(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget buildScrollableContainer(
      String type,
      double containerHeight,
      String selectedOption,
      List<String> options,
      ValueChanged<String> onSelected) {
    final colors = Theme.of(context).customColors;
    PageController controller;
    if (type == 'wick') {
      controller = _wickController;
    } else if (type == 'body') {
      controller = _bodyController;
    } else {
      controller = _tailController;
    }

    return SizedBox(
      height: containerHeight,
      child: PageView.builder(
        controller: controller,
        itemCount: options.length,
        onPageChanged: (index) => onSelected(options[index]),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selectedOption;
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              height: isSelected ? 260 : 120,
              width: isSelected ? 120 : 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colors.borderColorPrimary,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Center(
                child: Container(
                  color: model.getColor(option),
                  width: model.getContainerWidth(type, isSelected),
                  height: model.getContainerHeight(type, option, isSelected),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildResultContainer() {
    final colors = Theme.of(context).customColors;
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SlideTransition(
                  position: _wickAnimation,
                  child: Container(
                    color: model.getColor(model.selectedWick),
                    width: model.getContainerWidth('wick', true),
                    height: model.getContainerHeight(
                        'wick', model.selectedWick, true),
                  ),
                ),
                Container(
                  color: model.getColor(model.selectedBody),
                  width: model.getContainerWidth('body', true),
                  height: model.getContainerHeight(
                      'body', model.selectedBody, true),
                ),
                SlideTransition(
                  position: _tailAnimation,
                  child: Container(
                    color: model.getColor(model.selectedTail),
                    width: model.getContainerWidth('tail', true),
                    height: model.getContainerHeight(
                        'tail', model.selectedTail, true),
                  ),
                ),
              ],
            ),
          ),
          listEquals(model.correctOptions,
                  [model.selectedWick, model.selectedBody, model.selectedTail])
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  child: ButtonWidget(
                      color: colors.primary,
                      btnContent: "Next",
                      onTap: () {
                        widget.onNextClick();
                      }),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
