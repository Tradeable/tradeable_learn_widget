import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class WidgetBottomContainer extends StatelessWidget {
  final VoidCallback? onMenuClick;
  final Widget buttonWidget;

  const WidgetBottomContainer(
      {super.key, this.onMenuClick, required this.buttonWidget});

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
        decoration:
            BoxDecoration(color: colors.cardBasicBackground, boxShadow: [
          BoxShadow(
              color: colors.cardColorSecondary,
              offset: const Offset(0, -2),
              spreadRadius: 2,
              blurRadius: 1)
        ]),
        padding: const EdgeInsets.all(16),
        child: userActionContainer(context));
  }

  Widget userActionContainer(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Row(children: [
      Expanded(
        child: SizedBox(height: 54, child: buttonWidget),
      ),
      if (onMenuClick != null) ...[
        const SizedBox(width: 20),
        InkWell(
          onTap: () => onMenuClick,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.cardColorSecondary, width: 2)),
            child: Icon(
              Icons.more_vert,
              color: colors.primary,
            ),
          ),
        )
      ]
    ]);
  }
}
