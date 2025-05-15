import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tlw.dart';

class InfoBottomSheet extends StatelessWidget {
  final VoidCallback onNextClick;

  const InfoBottomSheet({super.key, required this.onNextClick});

  @override
  Widget build(BuildContext context) {
    final colors = TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles = TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBasicBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Image.asset(
                "assets/educorner_image.png",
                package: 'tradeable_learn_widget/lib',
                height: 120,
                fit: BoxFit.fitHeight,
              ),
            ),
            Text('Ready?', style: textStyles.largeBold),
            const SizedBox(height: 8),
            Text(
              'Now lets test what we have learned with some fun examples!',
              style: textStyles.smallNormal,
            ),
            const SizedBox(height: 20),
            ButtonWidget(
              color: colors.primary,
              btnContent: "Next",
              onTap: () {
                Navigator.of(context).pop();
                onNextClick();
              },
            ),
          ],
        ),
      ),
    );
  }
}
