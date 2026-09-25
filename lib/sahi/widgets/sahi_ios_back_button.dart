import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SahiIosBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const SahiIosBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Icon(
          Icons.arrow_back_ios,
          size: 12,
          color: colors.sahiCardTitleColor,
        ),
      ),
    );
  }
}
