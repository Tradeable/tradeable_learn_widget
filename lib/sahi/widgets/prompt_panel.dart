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
  final bool compact;

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
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          compact ? EdgeInsets.zero : const EdgeInsets.fromLTRB(12, 14, 0, 24),
      decoration: BoxDecoration(
        color: colors.dynamicChartInstructionBG,
        borderRadius: compact ? BorderRadius.zero : BorderRadius.circular(12),
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
                final labels = _tabLabels;
                final indices = _tabIndices;
                if (constraints.maxWidth >= _minTotalTabWidth) {
                  return Row(
                    children: [
                      for (var i = 0; i < labels.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Expanded(child: _buildTab(labels[i], indices[i])),
                      ],
                    ],
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < labels.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        _buildTab(labels[i], indices[i]),
                      ],
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

  List<String> get _tabLabels => compact
      ? const ['Questions', 'Response Archive']
      : const ['Instruction', 'Questions', 'Response Archive'];

  List<int> get _tabIndices => compact ? const [1, 2] : const [0, 1, 2];

  int get _activeTabIndex => compact && tabIndex == 0 ? 1 : tabIndex;

  Widget _buildTab(String label, int index) {
    final isActive = _activeTabIndex == index;
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
    return perTab * _tabIndices.length;
  }

  Widget _buildContent() {
    switch (_activeTabIndex) {
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
        if (compact) return questionsBody;
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
