import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/range_grid_widget/dotted_border_circle_painter.dart';
import 'package:tradeable_learn_widget/range_grid_widget/range_grid_model.dart';
import 'package:tradeable_learn_widget/range_grid_widget/stamp_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class RatingWidget extends StatefulWidget {
  final RangeGridSliderModel model;
  final VoidCallback onNextClick;

  const RatingWidget(
      {super.key, required this.model, required this.onNextClick});

  @override
  State<RatingWidget> createState() => _RangeGridSliderWidgetState();
}

class _RangeGridSliderWidgetState extends State<RatingWidget> {
  late RangeGridSliderModel model;
  String? draggedMedal;
  bool showErrorBorder = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    final textStyles = Theme.of(context).customTextStyles;

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 80),
                      color: Colors.white,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth / 2.4,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 100),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(154, 183, 204, 1),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16))),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth / 2,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: _scrollController,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Text(model.question,
                                      style: textStyles.mediumBold),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: DragTarget<String>(
                              builder: (BuildContext context,
                                  List<String?> candidateData,
                                  List<dynamic> rejectedData) {
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  height: 40,
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomPaint(
                                      painter: DottedBorderCirclePainter(),
                                      child: draggedMedal != null
                                          ? RotationTransition(
                                              turns:
                                                  const AlwaysStoppedAnimation(
                                                      -20 / 360),
                                              child: Center(
                                                child: Text(
                                                  draggedMedal!,
                                                  style: textStyles.largeBold
                                                      .copyWith(
                                                          fontSize: 26,
                                                          color: colors
                                                              .bullishColor),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ),
                                );
                              },
                              onAcceptWithDetails:
                                  (DragTargetDetails<String> details) {
                                if (details.data == model.correctResponse) {
                                  setState(() {
                                    draggedMedal = details.data;
                                    widget.onNextClick();
                                  });
                                } else {
                                  showError();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: model.options.length,
                      itemBuilder: (context, index) {
                        return Draggable<String>(
                          data: model.options[index],
                          feedback: StampContainer(
                            index: index,
                            value: model.options[index],
                            isDragging: true,
                          ),
                          childWhenDragging: Container(),
                          child: StampContainer(
                            index: index,
                            value: model.options[index],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 20);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: ButtonWidget(
                color: draggedMedal != null ? colors.primary : colors.secondary,
                btnContent: "Next",
                onTap: () {
                  if (draggedMedal != null) {
                    widget.onNextClick();
                  }
                }),
          ),
        ],
      );
    });
  }

  void showError() {
    setState(() {
      showErrorBorder = true;
    });
    Timer(const Duration(seconds: 3), () {
      setState(() {
        showErrorBorder = false;
      });
    });
  }
}
