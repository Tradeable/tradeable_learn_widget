import 'package:fin_chart/fin_chart.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tlw.dart';

class CustomDialogWidget extends StatelessWidget {
  final ShowPopupTask task;
  final VoidCallback moveNext;

  const CustomDialogWidget(
      {super.key, required this.task, required this.moveNext});

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(task.title, style: textStyles.mediumBold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(task.description),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => moveNext(),
              child: Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  color: colors.primary,
                ),
                child: Center(
                  child: Text(task.buttonText,
                      style: textStyles.mediumBold
                          .copyWith(fontSize: 16, color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
