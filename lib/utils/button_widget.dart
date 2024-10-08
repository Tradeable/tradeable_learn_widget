import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class ButtonWidget extends StatelessWidget {
  final Color color;
  final String btnContent;
  final VoidCallback onTap;

  const ButtonWidget(
      {super.key,
      required this.color,
      required this.btnContent,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).customTextStyles;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
        child: Center(
          child: Text(btnContent,
              style: textStyles.mediumBold
                  .copyWith(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }
}
