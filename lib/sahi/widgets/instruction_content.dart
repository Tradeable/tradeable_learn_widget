import 'package:fin_chart/models/tasks/add_prompt.task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/tool_tip_widget.dart';
import 'package:tradeable_learn_widget/sahi/widgets/sahi_tooltip_widget.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/sahi_markdown_config.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class InstructionContent extends StatelessWidget {
  final AddPromptTask? task;
  final CustomColors colors;

  const InstructionContent({
    super.key,
    required this.task,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '',
            style: TextStyle(
              fontSize: 13,
              color: colors.textColorSecondary,
            ),
          ),
        ),
      );
    }

    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
      child: SizedBox(
        key: ValueKey(task),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  task!.isExplanation
                      ? Text("Take Away",
                          style: textStyles.smallBold.copyWith(
                              color: colors.sahiToolbarActiveIconColor,
                              fontSize: 13))
                      : Text("Instruction",
                          style: textStyles.smallBold.copyWith(
                              color: colors.sahiToolbarActiveIconColor,
                              fontSize: 13)),
                  (task!.hint ?? "").isNotEmpty
                      ? SahiTooltip(
                          maxWidth: 300,
                          maxHeight: 150,
                          message: 'Hint!\n${task!.hint}',
                          child: Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.feedbackWidgetBG,
                            ),
                            child: SvgPicture.asset(
                              "assets/instruction_hint.svg",
                              package: 'tradeable_learn_widget/lib',
                              height: 16,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              MarkdownWidget(
                data: task?.promptText ?? "",
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                config: markdownConfig,
              )
            ],
          ),
        ),
      ),
    );
  }
}
