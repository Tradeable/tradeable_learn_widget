import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class OptionEduCornerGaugeWidget extends StatelessWidget {
  final Animation<double> needleAnimation;
  final bool toggleValue;
  final List<double> callValues;
  final List<double> putValues;

  const OptionEduCornerGaugeWidget({
    super.key,
    required this.needleAnimation,
    required this.toggleValue,
    required this.callValues,
    required this.putValues,
  });

  @override
  Widget build(BuildContext context) {
    final List<double> selectedValues = toggleValue ? callValues : putValues;

    final double min = selectedValues.reduce((a, b) => a < b ? a : b);
    final double max = selectedValues.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 180,
      width: 180,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 1000,
        axes: <RadialAxis>[
          RadialAxis(
            canScaleToFit: true,
            minimum: min,
            maximum: max,
            pointers: <GaugePointer>[
              NeedlePointer(
                value: needleAnimation.value,
                needleColor: Colors.red,
                needleLength: 0.9,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
