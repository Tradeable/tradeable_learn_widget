import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class AnimatedNumber extends StatefulWidget {
  final String value;
  final Duration duration;

  const AnimatedNumber({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _targetValue;

  @override
  void initState() {
    super.initState();
    _targetValue = double.tryParse(widget.value) ?? 0;

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: _targetValue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      double newValue = double.tryParse(widget.value) ?? 0;
      _targetValue = newValue;

      _animation = Tween<double>(
        begin: _animation.value,
        end: _targetValue,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final displayValue = _animation.value.toStringAsFixed(2);

        return Text(
          displayValue,
          style: textStyles.largeBold,
        );
      },
    );
  }
}
