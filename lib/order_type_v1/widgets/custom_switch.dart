import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/order_type_v1/utils/ui_constants.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final Duration animationDuration;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 100.0,
    this.height = 35.0,
    this.activeColor = UIConstants.switchActiveColor,
    this.inactiveColor = UIConstants.switchInactiveColor,
    this.thumbColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveWidth =
        math.max(80, MediaQuery.of(context).size.width * 0.17).toDouble();
    final responsiveHeight =
        math.max(30, MediaQuery.of(context).size.width * 0.075).toDouble();

    return GestureDetector(
      onTap: widget.onChanged != null
          ? () => widget.onChanged!(!widget.value)
          : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: responsiveWidth,
            height: responsiveHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: UIConstants.secondaryCardColor,
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  left: widget.value
                      ? responsiveWidth - responsiveHeight - 16
                      : 0,
                  top: 2,
                  child: Container(
                    width: responsiveHeight + 12,
                    height: responsiveHeight - 4,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.onChanged != null
                            ? Color.lerp(
                                widget.inactiveColor,
                                widget.activeColor,
                                _animation.value,
                              )!
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: widget.thumbColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.2 * 255).toInt()),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
