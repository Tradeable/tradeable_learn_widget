import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class OptionChainContainer extends StatelessWidget {
  final Widget child;

  const OptionChainContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 8, right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colors.optionChainBgColor,
          border: Border.all(color: colors.optionChainStrokeColor)),
      child: Container(
          margin: const EdgeInsets.only(top: 12, left: 8, right: 8),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14)),
              color: colors.cardBasicBackground,
              border: Border.all(color: colors.optionChainStrokeColor)),
          child: child),
    );
  }
}
