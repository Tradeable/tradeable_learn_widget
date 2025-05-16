import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class InfoTextContainer extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isRightAligned;

  const InfoTextContainer(
      {super.key, required this.text, this.icon, required this.isRightAligned});

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.optionChainStrokeColor, width: 2),
          color: colors.optionChainBgColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isRightAligned
              ? icon != null
                  ? Icon(icon)
                  : Container()
              : Container(),
          Text(text, style: textStyles.smallNormal),
          !isRightAligned
              ? icon != null
                  ? Icon(icon)
                  : Container()
              : Container(),
        ],
      ),
    );
  }
}
