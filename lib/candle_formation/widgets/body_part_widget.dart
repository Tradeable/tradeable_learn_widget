
import 'package:flutter/material.dart';

class CandleFormationPart extends StatefulWidget {
  final String type;
  final double height;
  final double width;
  final Color color;

  const CandleFormationPart({
    super.key,
    required this.type,
    required this.height,
    required this.width,
    required this.color,
  });

  @override
  State<StatefulWidget> createState() => _CandleFormationPartState();
}

class _CandleFormationPartState extends State<CandleFormationPart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: widget.height),
      duration: const Duration(milliseconds: 500),
      builder: (context, double value, child) {
        return Container(
          height: value,
          width: widget.width,
          decoration: BoxDecoration(color: widget.color),
        );
      },
    );
  }
}
