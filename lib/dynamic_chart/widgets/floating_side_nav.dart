import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';
import 'package:tradeable_learn_widget/tradeable_learn_widget.dart';

class FloatingSideNav extends StatefulWidget {
  final Function(String) onMenuItemClick;

  const FloatingSideNav({super.key, required this.onMenuItemClick});

  @override
  State<FloatingSideNav> createState() => _FloatingSideNavState();
}

class _FloatingSideNavState extends State<FloatingSideNav> {
  bool expanded = false;
  double top = 200;
  static const double expandedMenuHeight = 160;
  static const double minTop = 50;
  static const double maxBottomOffset = 200;

  bool get shouldExpandAbove {
    return top > MediaQuery.of(context).size.height / 2;
  }

  double get adjustedTop {
    if (expanded && shouldExpandAbove) {
      return (top - expandedMenuHeight).clamp(minTop, double.infinity);
    }
    return top;
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: adjustedTop,
      right: 0,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            top = (top + details.delta.dy).clamp(
              minTop,
              screenHeight - maxBottomOffset,
            );
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildMenuItems(colors),
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems(CustomColors colors) {
    final menuButton = _buildMenuButton(colors);
    final expandedMenu = _buildExpandedMenu(colors);

    if (shouldExpandAbove) {
      return [
        if (expanded) expandedMenu,
        menuButton,
      ];
    } else {
      return [
        menuButton,
        if (expanded) expandedMenu,
      ];
    }
  }

  Widget _buildMenuButton(CustomColors colors) {
    return InkWell(
      onTap: () => setState(() => expanded = !expanded),
      child: Container(
        width: 53,
        height: 40,
        decoration: BoxDecoration(
          color: expanded
              ? colors.primary
              : colors.primary.withAlpha((0.3 * 255).round()),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          ),
        ),
        child: Icon(
          expanded ? Icons.close : Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildExpandedMenu(CustomColors colors) {
    return Container(
      margin: EdgeInsets.only(
        top: shouldExpandAbove ? 0 : 8,
        bottom: shouldExpandAbove ? 8 : 0,
      ),
      width: 53,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          bottomLeft: Radius.circular(14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            for (final item in _menuItems) ...[
              _buildNavIcon(item['icon']!, item['type']!),
              if (item != _menuItems.last) const SizedBox(height: 6),
            ],
          ],
        ),
      ),
    );
  }

  static const List<Map<String, String>> _menuItems = [
    {'icon': 'assets/chat.svg', 'type': 'chat'},
    {'icon': 'assets/bookmark.svg', 'type': 'bookmark'},
    {'icon': 'assets/texttospeech.svg', 'type': 'texttospeech'},
  ];

  Widget _buildNavIcon(String icon, String type) {
    return InkWell(
      onTap: () => widget.onMenuItemClick(type),
      child: SvgPicture.asset(
        icon,
        package: 'tradeable_learn_widget/lib',
      ),
    );
  }
}
