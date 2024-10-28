import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/options_educorner/widgets/pushable_button.dart';

class OptionEducornerInfoBtn extends StatelessWidget {
  final String assetPath;
  final Color color;
  final VoidCallback action;

  const OptionEducornerInfoBtn(
      {super.key,
      required this.assetPath,
      required this.color,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: SubLevelButton(
        height: 50,
        elevation: 10,
        hslColor: HSLColor.fromColor(color),
        onPressed: () {
          action();
        },
        child: Align(
          alignment: const Alignment(0, -0.3),
          child: Image.asset(
            assetPath,
            height: 30,
          ),
        ),
      ),
    );
  }
}
