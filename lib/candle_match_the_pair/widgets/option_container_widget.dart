import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class Option {
  final String option;
  final Offset correctOffset;
  Offset offset;
  bool isCorrect = false;
  bool isSnapped = false;
  late Offset originalOffset;

  Option({
    required this.option,
    required this.offset,
    required this.correctOffset,
  }) {
    originalOffset = offset;
  }
}

class OptionContainer extends StatefulWidget {
  final Option option;
  final List<Offset> snapOffests;
  final Function(Option) onUpdate;
  final double width;
  final double height;

  const OptionContainer(
      {super.key,
      required this.option,
      required this.onUpdate,
      required this.snapOffests,
      required this.width,
      required this.height});

  @override
  State<OptionContainer> createState() => _OptionContainerState();
}

class _OptionContainerState extends State<OptionContainer>
    with TickerProviderStateMixin {
  bool isSnapped = false;
  late AnimationController controller;
  late Animation<Offset> animation;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.customColors;
    final textStyles = theme.customTextStyles;
    if (!isAnimating) {
      controller = AnimationController(
          duration: const Duration(milliseconds: 600), vsync: this)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            isAnimating = false;
          }
        })
        ..addListener(() {
          widget.onUpdate(widget.option..offset = animation.value);
        });
      animation = Tween<Offset>(
              begin: widget.option.offset, end: widget.option.originalOffset)
          .animate(
              CurvedAnimation(parent: controller, curve: Curves.bounceOut));
    }
    return Positioned(
      top: widget.option.offset.dy,
      left: widget.option.offset.dx,
      child: GestureDetector(
        onPanUpdate: (details) {
          isSnapped = false;

          widget.onUpdate(widget.option
            ..isSnapped = false
            ..offset = Offset(widget.option.offset.dx + details.delta.dx,
                widget.option.offset.dy + details.delta.dy));

          for (Offset element in widget.snapOffests) {
            if ((element - widget.option.offset).distance < 5) {
              isSnapped = true;
              widget.onUpdate(widget.option..offset = element);
            }
          }
        },
        onPanEnd: (details) {
          if (isSnapped) {
            if (widget.option.correctOffset == widget.option.offset) {
              widget.onUpdate(widget.option
                ..isCorrect = true
                ..isSnapped = true);
            } else {
              widget.onUpdate(widget.option
                ..isCorrect = false
                ..isSnapped = true);
            }
          } else {
            isAnimating = true;
            controller.forward();
            widget.onUpdate(widget.option
              ..isCorrect = false
              ..isSnapped = false);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              // color: widget.option.isSnapped
              //     ? widget.option.isCorrect
              //         ? colors.bullishColor
              //         : colors.bearishColor
              //     : colors.selectedItemColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isSnapped
                      ? Colors.transparent
                      : colors.borderColorPrimary,
                  width: 2)),
          width: widget.width,
          height: widget.height,
          child: Center(
            child: Text(
              widget.option.option,
              style: textStyles.smallBold,
            ),
          ),
        ),
      ),
    );
  }
}
