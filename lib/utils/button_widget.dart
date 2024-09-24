import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ButtonWidget extends StatelessWidget {
  final Color color;
  final String btnContent;

  const ButtonWidget(
      {super.key, required this.color, required this.btnContent});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Center(
        child: Text(btnContent,
            style: textStyles.mediumBold
                .copyWith(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
