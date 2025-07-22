import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class WidgetBottomContainer extends StatelessWidget {
  final String buttonContent;
  final VoidCallback onNextClick;
  final VoidCallback onMenuClick;

  const WidgetBottomContainer(
      {super.key,
      required this.buttonContent,
      required this.onNextClick,
      required this.onMenuClick});

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
        child: userActionContainer(context, buttonContent));
  }

  Widget userActionContainer(BuildContext context, String buttonContent) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Row(children: [
      Expanded(
        child: ButtonWidget(
          color: colors.primary,
          btnContent: buttonContent,
          onTap: () => onNextClick(),
        ),
      ),
      const SizedBox(width: 20),
      InkWell(
        onTap: () => onMenuClick(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.cardColorSecondary, width: 2)),
          child: Icon(
            Icons.more_vert,
            color: colors.primary,
          ),
        ),
      )
    ]);
  }
}
