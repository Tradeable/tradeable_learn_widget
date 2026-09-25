import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SahiCompactTabBar extends StatelessWidget {
  final List<Map<String, String>> tabs;
  final int currentPageIndex;
  final ValueChanged<int> onTabTap;
  final VoidCallback? onInstructionTap;
  final VoidCallback? onTaskTap;

  const SahiCompactTabBar({
    super.key,
    required this.tabs,
    required this.currentPageIndex,
    required this.onTabTap,
    this.onInstructionTap,
    this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.sahiCardBorderColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(tabs.length, (index) {
                  final tab = tabs[index];
                  return _CompactTab(
                    label: tab["title"] ?? "",
                    selected: index == currentPageIndex,
                    onTap: () => onTabTap(index),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _CornerAction(
            onTap: onInstructionTap,
            child: Icon(
              Icons.menu_book_outlined,
              size: 16,
              color: colors.sahiPrimaryTextColor,
            ),
          ),
          const SizedBox(width: 8),
          _CornerAction(
            onTap: onTaskTap,
            child: Text(
              "Task",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.sahiPrimaryTextColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _CompactTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CompactTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final color = selected ? Colors.black : colors.secondary;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 44,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 24),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: color,
                    ),
                  ),
                ),
                if (selected)
                  Positioned(
                    left: 6,
                    right: 6,
                    bottom: 3,
                    child: Container(height: 2, color: Colors.black),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerAction extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _CornerAction({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Material(
      color: colors.sahiUtilityBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ),
    );
  }
}
