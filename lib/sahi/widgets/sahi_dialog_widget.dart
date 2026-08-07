import 'package:fin_chart/fin_chart.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tlw.dart';

class SahiDialogWidget extends StatefulWidget {
  final ShowPopupTask task;
  final VoidCallback moveNext;

  const SahiDialogWidget(
      {super.key, required this.task, required this.moveNext});

  @override
  State<SahiDialogWidget> createState() => _SahiDialogWidgetState();
}

class _SahiDialogWidgetState extends State<SahiDialogWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    final task = widget.task;
    final moveNext = widget.moveNext;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400, maxWidth: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: Color.fromRGBO(255, 255, 255, 0.2), width: 1),
          color: colors.cardBasicBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.25 * 255).round()),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            MarkdownWidget(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              data: task.title,
              config: MarkdownConfig(configs: [
                PConfig(
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                H1Config(
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ]),
            ),
            Flexible(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: MarkdownWidget(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      data: task.description),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: InkWell(
                onTap: () => moveNext(),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colors.sahiToolbarActiveIconColor,
                  ),
                  child: Center(
                    child: Text(task.buttonText,
                        style: textStyles.mediumBold
                            .copyWith(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
