import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ButtonWidget extends StatelessWidget {
  final Color color;
  final String btnContent;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final BorderRadiusGeometry? borderRadius;

  const ButtonWidget(
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
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(6),
          color: color,
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
