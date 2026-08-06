import 'package:fin_chart/models/tasks/show_sidenav.task.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/utils/sahi_markdown_config.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class QuestionsTab extends StatelessWidget {
  final List<ShowSideNavTask> tasks;
  final String? expandedTaskId;
  final Map<String, String?> selectedDescriptions;
  final CustomColors colors;
  final void Function(ShowSideNavTask task, String description) onOptionSelect;

  const QuestionsTab({
    super.key,
    required this.tasks,
    required this.expandedTaskId,
    required this.selectedDescriptions,
    required this.colors,
    required this.onOptionSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: tasks.map(_buildQuestionCard).toList(),
    );
  }

  Widget _buildQuestionCard(ShowSideNavTask task) {
    final isExpanded = expandedTaskId == task.id;
    final selectedDesc = selectedDescriptions[task.id];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x14030405)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.sahiPrimaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuestionOption(
              task, task.primaryButtonText, task.primaryDescription),
          if (task.secondaryButtonText.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildQuestionOption(
                task, task.secondaryButtonText, task.secondaryDescription),
            const SizedBox(height: 10),
          ],
          if (isExpanded && selectedDesc != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.dynamicChartInstructionBG,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x14030405)),
              ),
              child: MarkdownWidget(
                data: selectedDesc,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                config: markdownConfig,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionOption(
      ShowSideNavTask task, String label, String description) {
    final isSelected = selectedDescriptions[task.id] == description;
    return GestureDetector(
      onTap: () => onOptionSelect(task, description),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.sahiToolbarActiveBg : const Color(0xFFFBFBFD),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isSelected
                ? colors.sahiToolbarActiveIconColor
                : const Color(0x14030405),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(
                Icons.circle_outlined,
                size: 16,
                color: isSelected
                    ? colors.sahiTabActiveBg
                    : colors.sahiTabInactiveText.withAlpha((0.4 * 255).round()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: colors.sahiPrimaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
