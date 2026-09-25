import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class CourseProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final double? borderRadius;
  final Color? progressBgColor;

  const CourseProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
    this.borderRadius,
    this.progressBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      child: Stack(
        children: [
          Container(
            height: height,
            width: double.infinity,
            color: progressBgColor ?? colors.sahiStreakProgressBg,
          ),
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.sahiGradientPrimaryStart,
                    colors.sahiGradientPrimaryEnd,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
