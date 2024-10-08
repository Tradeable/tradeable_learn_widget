import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class LearnErrorBorder extends StatelessWidget {
  final bool showErrorBody;
  final Widget child;
  final Color? color;

  const LearnErrorBorder(
      {super.key,
        required this.showErrorBody,
        required this.child,
        this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).customColors.background,
        gradient: showErrorBody
            ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color ?? Colors.red.withOpacity(0.5),
            Colors.transparent,
          ],
        )
            : null,
      ),
      child: child,
    );
  }
}
