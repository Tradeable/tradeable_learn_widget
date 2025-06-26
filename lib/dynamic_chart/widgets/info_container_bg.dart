import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class InfoContainerBg extends StatelessWidget {
  final Widget child;

  const InfoContainerBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.cardColorSecondary,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.buttonColor,
          border: Border.all(color: colors.cardColorSecondary),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: child,
      ),
    );
  }
}
