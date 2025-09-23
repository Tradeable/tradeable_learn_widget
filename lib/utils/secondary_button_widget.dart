import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SecondaryButtonWidget extends StatelessWidget {
  final Color color;
  final String btnContent;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;

  const SecondaryButtonWidget(
      {super.key,
      required this.color,
      required this.btnContent,
      required this.onTap,
      this.textStyle,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  colors.borderColorSecondary.withAlpha((0.4 * 255).round())),
          borderRadius: borderRadius ?? BorderRadius.circular(6),
          color: color,
        ),
        child: Center(
          child: Text(btnContent,
              style: textStyle ??
                  textStyles.mediumBold
                      .copyWith(fontSize: 16, color: colors.primary)),
        ),
      ),
    );
  }
}
