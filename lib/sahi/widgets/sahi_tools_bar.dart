import 'package:fin_chart/models/sahi_tools_model.dart';
import 'package:fin_chart/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/dynamic_chart/widgets/sahi_icon_helpers.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class SahiToolsBar extends StatelessWidget {
  final List<SahiToolsModel> tools;
  final void Function(String toolName)? onToolTap;
  final Widget? trailing;

  const SahiToolsBar({
    super.key,
    required this.tools,
    this.onToolTap,
    this.trailing,
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
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: visibleTools.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final tool = visibleTools[index];
                    return GestureDetector(
                      onTap: tool.isEnabled
                          ? () => onToolTap?.call(tool.title)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: tool.isEnabled ? colors.sahiPanelItemBg : null,
                          borderRadius: BorderRadius.circular(6),
                          border: tool.isEnabled
                              ? Border.all(
                                  color: colors.sahiPrimaryTextColor,
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
                              color: tool.isEnabled
                                  ? colors.sahiChipEnabledText
                                  : colors.sahiChipDisabledText,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              tool.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: tool.isEnabled
                                    ? colors.sahiChipEnabledText
                                    : colors.sahiChipDisabledText,
                              ),
                            ),
                          ],
                        ),
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
}
