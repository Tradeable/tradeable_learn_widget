import 'package:flutter/material.dart';
import 'package:fin_chart/models/tasks/show_sidenav.task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class SideNavPanel extends StatelessWidget {
  final List<ShowSideNavTask> tasks;
  final String? expandedId;
  final void Function(String? id) onExpandedChange;
  final Map<String, String?> selectedDescriptions;
  final void Function(String taskId, String? description) onDescriptionSelect;
  final VoidCallback closeSidenav;
  final Function(String) onActionTaken;

  const SideNavPanel({
    super.key,
    required this.tasks,
    required this.expandedId,
    required this.onExpandedChange,
    required this.selectedDescriptions,
    required this.onDescriptionSelect,
    required this.closeSidenav,
    required this.onActionTaken,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    final lastId = tasks.last.id;
    final effectiveExpandedId = expandedId;
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TLW().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Column(
      children: [
        _header(colors, textStyles),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: tasks.map((t) {
              final isExpanded = effectiveExpandedId == t.id;
              final selectedDescription = selectedDescriptions[t.id];
              return _taskTile(
                task: t,
                isExpanded: isExpanded,
                lastId: lastId,
                colors: colors,
                textStyles: textStyles,
                selectedDescription: selectedDescription,
              );
            }).toList(),
          ),
        ),
        _bottomButtons(colors),
      ],
    );
  }

  Widget _header(CustomColors colors, CustomStyles textStyles) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: colors.primary,
      child: Center(
        child: Text("Response Archive",
            style: textStyles.mediumBold.copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _taskTile({
    required ShowSideNavTask task,
    required bool isExpanded,
    required String lastId,
    required CustomColors colors,
    required CustomStyles textStyles,
    required String? selectedDescription,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.3 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Card(
            elevation: 1,
            color: Colors.white,
            margin: EdgeInsets.zero,
            child: ExpansionTile(
              key: ValueKey("${task.id}_${isExpanded ? 'open' : 'closed'}"),
              initiallyExpanded: isExpanded,
              title: Text(task.title, style: textStyles.smallBold),
              shape: const RoundedRectangleBorder(side: BorderSide.none),
              collapsedShape:
                  const RoundedRectangleBorder(side: BorderSide.none),
              onExpansionChanged: (open) {
                if (open) {
                  onExpandedChange(task.id);
                } else if (isExpanded) {
                  onExpandedChange(null);
                }
              },
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: _optionButton(task.id, task.primaryButtonText,
                              task.primaryDescription, colors, textStyles)),
                      if (task.secondaryButtonText.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Expanded(
                            child: _optionButton(
                                task.id,
                                task.secondaryButtonText,
                                task.secondaryButtonText,
                                colors,
                                textStyles)),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            if (selectedDescription != null) ...[
              const SizedBox(height: 12),
              _descriptionCard(selectedDescription),
            ],
            const SizedBox(height: 12),
            ButtonWidget(
              color: colors.primary,
              btnContent: "Understood",
              onTap: closeSidenav,
            ),
          ]
        ],
      ),
    );
  }

  Widget _optionButton(String taskId, String label, String? description,
      CustomColors colors, CustomStyles textStyles) {
    final isSelected = selectedDescriptions[taskId] == description;

    return InkWell(
      onTap: () {
        onExpandedChange(taskId);
        onDescriptionSelect(taskId, description);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            label,
            style: textStyles.smallBold.copyWith(
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _descriptionCard(String description) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: MarkdownWidget(
          data: description,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ),
    );
  }

  Widget _bottomButtons(CustomColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _actionButton("Talk to Expert", "assets/talktoexpert.svg",
                "talktoexpert", colors),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _actionButton(
                "Take a Trade", "assets/takeatrade.svg", "takeatrade", colors),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      String label, String asset, String action, CustomColors colors) {
    return ElevatedButton(
      onPressed: () => onActionTaken(action),
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(width: 10),
          SvgPicture.asset(asset,
              package: 'tradeable_learn_widget/lib', height: 20),
        ],
      ),
    );
  }
}
