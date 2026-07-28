import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/app_theme.dart';

class SahiToolbarItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SahiToolbarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class SahiFloatingToolbar extends StatelessWidget {
  final List<SahiToolbarItem> topItems;
  final List<SahiToolbarItem> bottomItems;
  final int selectedIndex;

  const SahiFloatingToolbar({
    super.key,
    required this.topItems,
    required this.bottomItems,
    this.selectedIndex = -1,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      width: 80,
      margin: EdgeInsets.fromLTRB(12, 14, 12, 24),
      decoration: BoxDecoration(
        color: colors.sahiToolbarBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.sahiToolbarShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          for (int i = 0; i < topItems.length; i++)
            _ToolbarButton(
              item: topItems[i],
              isActive: i == selectedIndex,
              colors: colors,
            ),
          const Spacer(),
          for (int i = 0; i < bottomItems.length; i++)
            _ToolbarButton(
              item: bottomItems[i],
              isActive: (topItems.length + i) == selectedIndex,
              colors: colors,
            ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final SahiToolbarItem item;
  final bool isActive;
  final ThemeColors colors;

  const _ToolbarButton({
    required this.item,
    required this.isActive,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive
        ? colors.sahiToolbarActiveIconColor
        : colors.sahiToolbarIconColor;
    final textColor = isActive
        ? colors.sahiToolbarActiveIconColor
        : colors.sahiToolbarIconColor;
    final bgColor = isActive ? colors.sahiToolbarActiveBg : Colors.transparent;

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 20, color: iconColor),
            if (item.label.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
