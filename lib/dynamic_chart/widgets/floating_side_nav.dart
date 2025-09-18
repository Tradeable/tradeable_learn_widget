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

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Positioned(
      top: top,
      right: 0,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            top += details.delta.dy;
            if (top < 50) top = 50;
            if (top > MediaQuery.of(context).size.height - 200) {
              top = MediaQuery.of(context).size.height - 200;
            }
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => setState(() => expanded = !expanded),
              child: Container(
                width: 53,
                height: 40,
                decoration: BoxDecoration(
                  color: expanded
                      ? colors.primary
                      : colors.primary.withAlpha((0.2 * 255).round()),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
                child: Icon(expanded ? Icons.close : Icons.menu,
                    color: Colors.white),
              ),
            ),
            if (expanded)
              Container(
                margin: const EdgeInsets.only(top: 8),
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
                      _buildNavIcon("assets/chat.svg", "chat"),
                      const SizedBox(height: 6),
                      _buildNavIcon("assets/bookmark.svg", "bookmark"),
                      const SizedBox(height: 6),
                      _buildNavIcon("assets/texttospeech.svg", "texttospeech"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(String icon, String type) {
    return InkWell(
      onTap: () {
        widget.onMenuItemClick(type);
      },
      child: SvgPicture.asset(
        icon,
        package: 'tradeable_learn_widget/lib',
      ),
    );
  }
}
