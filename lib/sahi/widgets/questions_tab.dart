import 'package:fin_chart/models/tasks/show_sidenav.task.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/utils/sahi_markdown_config.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class QuestionsTab extends StatefulWidget {
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
  State<QuestionsTab> createState() => _QuestionsTabState();
}

class _QuestionsTabState extends State<QuestionsTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Animation<double> _cardEntrance(int index) {
    final start = (index * 0.08).clamp(0.0, 0.65);
    return CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (var i = 0; i < widget.tasks.length; i++)
          _buildAnimatedCard(widget.tasks[i], i),
      ],
    );
  }

  Widget _buildAnimatedCard(ShowSideNavTask task, int index) {
    final animation = _cardEntrance(index);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(animation),
        child: _buildQuestionCard(task),
      ),
    );
  }

  Widget _buildQuestionCard(ShowSideNavTask task) {
    final isExpanded = widget.expandedTaskId == task.id;
    final selectedDesc = widget.selectedDescriptions[task.id];

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
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: widget.colors.sahiPrimaryTextColor,
                  ),
                ),
              ),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOut,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: isExpanded
                      ? widget.colors.sahiToolbarActiveIconColor
                      : widget.colors.sahiToolbarIconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _AnimatedQuestionOption(
            label: task.primaryButtonText,
            isSelected: widget.selectedDescriptions[task.id] ==
                task.primaryDescription,
            colors: widget.colors,
            onTap: () => widget.onOptionSelect(task, task.primaryDescription),
          ),
          if (task.secondaryButtonText.isNotEmpty) ...[
            const SizedBox(height: 8),
            _AnimatedQuestionOption(
              label: task.secondaryButtonText,
              isSelected: widget.selectedDescriptions[task.id] ==
                  task.secondaryDescription,
              colors: widget.colors,
              onTap: () =>
                  widget.onOptionSelect(task, task.secondaryDescription),
            ),
            const SizedBox(height: 10),
          ],
          AnimatedSize(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: isExpanded && selectedDesc != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _DescriptionReveal(
                      description: selectedDesc,
                      colors: widget.colors,
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _DescriptionReveal extends StatelessWidget {
  final String description;
  final CustomColors colors;

  const _DescriptionReveal({required this.description, required this.colors});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.dynamicChartInstructionBG,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x14030405)),
        ),
        child: MarkdownWidget(
          data: description,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          config: markdownConfig,
        ),
      ),
    );
  }
}

class _AnimatedQuestionOption extends StatefulWidget {
  final String label;
  final bool isSelected;
  final CustomColors colors;
  final VoidCallback onTap;

  const _AnimatedQuestionOption({
    required this.label,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  State<_AnimatedQuestionOption> createState() =>
      _AnimatedQuestionOptionState();
}

class _AnimatedQuestionOptionState extends State<_AnimatedQuestionOption> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final isSelected = widget.isSelected;
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.sahiToolbarActiveBg
                : const Color(0xFFFBFBFD),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: isSelected
                  ? colors.sahiToolbarActiveIconColor
                  : const Color(0x14030405),
              width: isSelected ? 1.4 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.sahiToolbarActiveIconColor
                          .withAlpha((0.10 * 255).round()),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                  child: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          key: const ValueKey('selected'),
                          size: 18,
                          color: colors.sahiTabActiveBg,
                        )
                      : Icon(
                          Icons.circle_outlined,
                          key: const ValueKey('idle'),
                          size: 18,
                          color: colors.sahiTabInactiveText
                              .withAlpha((0.4 * 255).round()),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.sahiPrimaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
