import 'package:fin_chart/models/tasks/add_core_concept.task.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:tradeable_learn_widget/sahi/widgets/instruction_content.dart';
import 'package:tradeable_learn_widget/utils/sahi_markdown_config.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class PromptPanel extends StatelessWidget {
  final CustomColors colors;
  final int tabIndex;
  final ValueChanged<int> onTabChange;
  final InstructionContent instructionBody;
  final Widget questionsBody;
  final Widget? responseArchiveBody;
  final Widget? actionContainer;
  final AddCoreConceptTask? coreConcepts;

  const PromptPanel({
    super.key,
    required this.colors,
    required this.tabIndex,
    required this.onTabChange,
    required this.instructionBody,
    required this.questionsBody,
    this.coreConcepts,
    this.responseArchiveBody,
    this.actionContainer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 14, 0, 24),
      decoration: BoxDecoration(
        color: colors.dynamicChartInstructionBG,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0x14030405),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= _minTotalTabWidth) {
                  return Row(
                    children: [
                      Expanded(child: _buildTab('Instruction', 0)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTab('Questions', 1)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTab('Response Archive', 2)),
                    ],
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTab('Instruction', 0),
                      const SizedBox(width: 8),
                      _buildTab('Questions', 1),
                      const SizedBox(width: 8),
                      _buildTab('Response Archive', 2),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildContent()),
          if (actionContainer != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: actionContainer,
            ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = tabIndex == index;
    final tabColor =
        isActive ? colors.sahiTopBarBorder : colors.sahiToolbarIconColor;
    return GestureDetector(
      onTap: () => onTabChange(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? tabColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: tabColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  double get _minTotalTabWidth {
    final painter = TextPainter(
      text: const TextSpan(
        text: 'Response Archive',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final perTab = painter.width + 24;
    return perTab * 3;
  }

  Widget _buildContent() {
    switch (tabIndex) {
      case 1:
        return questionsBody;
      case 2:
        return responseArchiveBody ??
            Center(
              child: Text(
                'No responses yet',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textColorSecondary,
                ),
              ),
            );
      default:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                instructionBody,
                if (coreConcepts != null && coreConcepts!.title.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                      // margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(colors: [
                            Color.fromRGBO(238, 228, 247, 1),
                            Color.fromRGBO(251, 247, 243, 1)
                          ])),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coreConcepts!.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colors.sahiToolbarActiveIconColor,
                              ),
                            ),
                            if (coreConcepts!.description.isNotEmpty)
                              MarkdownWidget(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                data: coreConcepts!.description,
                                config: coreConceptConfig,
                              ),
                          ],
                        ),
                      ))
                ],
              ],
            ),
          ),
        );
    }
  }
}
