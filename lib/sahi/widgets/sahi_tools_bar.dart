import 'package:fin_chart/models/sahi_tools_model.dart';
import 'package:fin_chart/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/sahi_icon_helpers.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class SahiToolsBar extends StatelessWidget {
  final List<SahiToolsModel> tools;
  final void Function(String toolName)? onToolTap;
  final Widget? trailing;
  final String? activeToolTitle;

  const SahiToolsBar({
    super.key,
    required this.tools,
    this.onToolTap,
    this.trailing,
    this.activeToolTitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final visibleTools = tools.where((t) => t.isVisible).toList();

    if (visibleTools.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Color(0xffFBFBFD),
        border: Border(
          bottom: BorderSide(color: colors.sahiDivider, width: 0.35),
          top: BorderSide(color: colors.sahiDivider, width: 0.35),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Text(
            'TOOLS',
            style: TextStyle(
              color: colors.sahiTextPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              child: SizedBox(
                height: 46,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: visibleTools.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final tool = visibleTools[index];
                    final isActive = tool.title == activeToolTitle;
                    return GestureDetector(
                      onTap: tool.isEnabled
                          ? () => onToolTap?.call(tool.title)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: isActive
                            ? _GlowingToolChip(
                                color: colors.sahiTabActiveBg,
                                child: _buildToolChip(colors, tool, isActive),
                              )
                            : _buildToolChip(colors, tool, isActive),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  Widget _buildToolChip(
      CustomColors colors, SahiToolsModel tool, bool isActive) {
    final enabled = tool.isEnabled;
    final foregroundColor = !enabled
        ? colors.sahiChipDisabledText
        : isActive
            ? colors.sahiTabActiveText
            : colors.sahiChipEnabledText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: !enabled
            ? null
            : isActive
                ? colors.sahiTabActiveBg
                : colors.sahiPanelItemBg,
        borderRadius: BorderRadius.circular(6),
        border: enabled
            ? Border.all(
                color: isActive
                    ? colors.sahiTabActiveBg
                    : colors.sahiPrimaryTextColor,
                width: 1,
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getIndicatorIconForName(tool.title),
            size: 13,
            color: foregroundColor,
          ),
          const SizedBox(width: 5),
          Text(
            tool.title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowingToolChip extends StatefulWidget {
  final Widget child;
  final Color color;

  const _GlowingToolChip({required this.child, required this.color});

  @override
  State<_GlowingToolChip> createState() => _GlowingToolChipState();
}

class _GlowingToolChipState extends State<_GlowingToolChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final glow = _pulse.value;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: widget.color.withAlpha((glow * 0.6 * 255).round()),
                blurRadius: 3 + glow * 6,
                spreadRadius: glow * 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
