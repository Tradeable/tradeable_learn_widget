import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ButtonWidget extends StatelessWidget {
  final Color color;
  final String btnContent;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;
  final List<Color>? gradientColors;
  final double? width;
  final BorderSide? borderSide;
  final EdgeInsetsGeometry? padding;

  const ButtonWidget(
      {super.key,
      required this.color,
      required this.btnContent,
      required this.onTap,
      this.textStyle,
      this.borderRadius,
      this.gradientColors,
      this.width = double.infinity,
      this.borderSide,
      this.padding});

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final useGradient = gradientColors != null;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: padding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(6),
          border:
              borderSide == null ? null : Border.fromBorderSide(borderSide!),
          gradient:
              useGradient ? LinearGradient(colors: gradientColors!) : null,
          color: useGradient ? null : color,
        ),
        child: Center(
          child: Text(btnContent,
              style: textStyle ??
                  textStyles.mediumBold
                      .copyWith(fontSize: 16, color: Colors.white)),
        ),
      ),
    );
  }
}
