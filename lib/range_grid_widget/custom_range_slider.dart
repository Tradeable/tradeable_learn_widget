import 'package:flutter/material.dart';

class CustomRangeSlider extends StatelessWidget {
  final int divisions;
  final ValueChanged<double>? onChanged;
  final double value;

  const CustomRangeSlider({
    required this.divisions,
    this.onChanged,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      divisions: divisions,
      onChanged: onChanged,
      value: value,
      min: 0,
      max: divisions.toDouble(),
      activeColor: Colors.blue,
      inactiveColor: Colors.grey,
    );
  }
}
