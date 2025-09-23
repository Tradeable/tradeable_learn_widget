import 'package:fin_chart/models/tasks/show_bottom_sheet.task.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tlw.dart';

class CustomBottomSheetWidget extends StatelessWidget {
  final bool isCorrect;
  final ShowBottomSheetTask task;
  final VoidCallback moveNext;

  const CustomBottomSheetWidget({
    super.key,
    required this.task,
    required this.moveNext,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            color: colors.cardBasicBackground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              MarkdownWidget(
                data: task.title,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                config: MarkdownConfig(configs: [
                  H1Config(
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
              ),
              const SizedBox(height: 10),
              if (task.showImage) ...[
                const SizedBox(height: 10),
                Image.asset(
                  "assets/educorner_image.png",
                  package: 'tradeable_learn_widget/lib',
                  height: 120,
                  fit: BoxFit.fitHeight,
                ),
              ],
              const SizedBox(height: 6),
              MarkdownWidget(
                  data: task.description,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true),
              const SizedBox(height: 16),
              task.secondaryButtonText == null
                  ? SizedBox(
                      width: double.infinity,
                      child: ButtonWidget(
                          color: colors.primary,
                          btnContent: task.primaryButtonText,
                          onTap: () => moveNext()))
                  : Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () => moveNext(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: colors.buttonColor,
                                border: Border.all(
                                    color: colors.borderColorSecondary)),
                            child: Center(
                              child: Text(
                                  task.secondaryButtonText ?? "Continue",
                                  style: textStyles.mediumBold.copyWith(
                                      fontSize: 16, color: colors.primary)),
                            ),
                          ),
                        )),
                        const SizedBox(width: 8),
                        Expanded(
                            child: ButtonWidget(
                                color: colors.primary,
                                btnContent: task.primaryButtonText,
                                onTap: () => moveNext())),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
