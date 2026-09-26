import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/sahi_markdown_config.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SahiCompactTabBar extends StatefulWidget {
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
  State<SahiCompactTabBar> createState() => SahiCompactTabBarState();
}

class SahiCompactTabBarState extends State<SahiCompactTabBar> {
  final LayerLink _taskLink = LayerLink();
  final LayerLink _bookLink = LayerLink();
  OverlayEntry? _tooltipEntry;
  Timer? _mergeWindow;
  List<_TooltipSection> _sections = const [];
  LayerLink? _activeLink;
  bool _activeAtTopRight = false;

  @override
  void dispose() {
    _mergeWindow?.cancel();
    _tooltipEntry?.remove();
    super.dispose();
  }

  void showInstructionTooltip(
    String text, {
    LayerLink? link,
    bool atTopRight = false,
  }) {
    _showTooltip(
      link: link ?? _taskLink,
      section: _TooltipSection(Icons.lightbulb_outline, text),
      atTopRight: atTopRight,
    );
  }

  void showKnowledgeHubTooltip(
    String text, {
    LayerLink? link,
    bool atTopRight = false,
  }) {
    _showTooltip(
      link: link ?? _bookLink,
      section: _TooltipSection(Icons.menu_book_outlined, text),
      atTopRight: atTopRight,
    );
  }

  void _showTooltip({
    required LayerLink link,
    required _TooltipSection section,
    required bool atTopRight,
  }) {
    if (!mounted || section.text.trim().isEmpty) return;

    final openEntry = _tooltipEntry;
    if (openEntry != null && _mergeWindow?.isActive == true) {
      _sections = [..._sections, section];
      _openMergeWindow();
      openEntry.markNeedsBuild();
      return;
    }

    _sections = [section];
    _activeLink = link;
    _activeAtTopRight = atTopRight;
    openEntry?.remove();

    _tooltipEntry = OverlayEntry(
      builder: (context) => _InstructionTooltipOverlay(
        link: _activeLink!,
        sections: _sections,
        atTopRight: _activeAtTopRight,
        onDismiss: hideInstructionTooltip,
      ),
    );
    Overlay.of(context).insert(_tooltipEntry!);
    _openMergeWindow();
  }

  void _openMergeWindow() {
    _mergeWindow?.cancel();
    _mergeWindow = Timer(const Duration(milliseconds: 1500), () {});
  }

  void hideInstructionTooltip() {
    _mergeWindow?.cancel();
    _mergeWindow = null;
    _tooltipEntry?.remove();
    _tooltipEntry = null;
    _sections = const [];
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final accent = colors.sahiGradientPrimaryStart;

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
                children: List.generate(widget.tabs.length, (index) {
                  final tab = widget.tabs[index];
                  return _CompactTab(
                    label: tab["title"] ?? "",
                    selected: index == widget.currentPageIndex,
                    onTap: () => widget.onTabTap(index),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CompositedTransformTarget(
            link: _bookLink,
            child: _CornerAction(
              onTap: widget.onInstructionTap,
              child: Icon(
                Icons.menu_book_outlined,
                size: 16,
                color: accent,
              ),
            ),
          ),
          const SizedBox(width: 8),
          CompositedTransformTarget(
            link: _taskLink,
            child: _CornerAction(
              onTap: () {
                hideInstructionTooltip();
                widget.onTaskTap?.call();
              },
              child: Text(
                "Task",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _TooltipSection {
  final IconData icon;
  final String text;

  const _TooltipSection(this.icon, this.text);
}

class _InstructionTooltipOverlay extends StatefulWidget {
  final LayerLink link;
  final List<_TooltipSection> sections;
  final bool atTopRight;
  final VoidCallback onDismiss;

  const _InstructionTooltipOverlay({
    required this.link,
    required this.sections,
    required this.atTopRight,
    required this.onDismiss,
  });

  @override
  State<_InstructionTooltipOverlay> createState() =>
      _InstructionTooltipOverlayState();
}

class _InstructionTooltipOverlayState extends State<_InstructionTooltipOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final media = MediaQuery.of(context);
    final tooltipWidth = math.min(210.0, media.size.width * 0.55);
    final targetAnchor =
        widget.atTopRight ? Alignment.topRight : Alignment.bottomRight;
    const followerAnchor = Alignment.topRight;
    final offset = widget.atTopRight ? const Offset(0, 44) : const Offset(0, 8);

    return Stack(
      children: [
        Positioned.fill(
          child: ModalBarrier(
            color: Colors.transparent,
            dismissible: true,
            onDismiss: widget.onDismiss,
          ),
        ),
        CompositedTransformFollower(
          link: widget.link,
          targetAnchor: targetAnchor,
          followerAnchor: followerAnchor,
          offset: offset,
          child: FadeTransition(
            opacity: _controller,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.4),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                    parent: _controller, curve: Curves.easeOutCubic),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onDismiss,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: tooltipWidth,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.sahiUtilityBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.sahiTabBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(38),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0;
                                i < widget.sections.length;
                                i++) ...[
                              if (i > 0) ...[
                                const SizedBox(height: 10),
                                Divider(
                                  height: 1,
                                  color: colors.sahiTabBorder,
                                ),
                                const SizedBox(height: 10),
                              ],
                              Icon(
                                widget.sections[i].icon,
                                size: 16,
                                color: colors.sahiGradientPrimaryStart,
                              ),
                              const SizedBox(height: 8),
                              MarkdownWidget(
                                data: widget.sections[i].text,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                config: tooltipMarkdownConfig(
                                  colors.sahiPrimaryTextColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
