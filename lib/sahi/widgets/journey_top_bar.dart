import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_item.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_toolbar_item.dart';
import 'package:tradeable_learn_widget/sahi/widgets/sahi_ios_back_button.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class JourneyTopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onWatch;
  final List<JourneyItem> journeyItems;
  final bool muted;

  const JourneyTopBar({
    super.key,
    required this.onBack,
    required this.onWatch,
    this.journeyItems = const [],
    this.muted = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;
    final brandColor = colors.sahiGradientPrimaryStart;

    return AppBar(
      backgroundColor: colors.sahiMobileTabBarBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      toolbarHeight: preferredSize.height,
      titleSpacing: 16,
      title: Row(
        children: [
          SahiIosBackButton(onTap: onBack),
          const SizedBox(width: 12),
          _WatchButton(
            onPressed: onWatch,
            startColor: colors.sahiGradientPrimaryStart,
            endColor: colors.sahiGradientPrimaryEnd,
            primaryColor: muted ? brandColor : colors.primary,
            muted: muted,
          ),
          const SizedBox(width: 20),
          const Text("JOURNEY", style: TextStyle(fontSize: 10)),
          if (journeyItems.isNotEmpty) ...[
            const SizedBox(width: 12),
            Expanded(
              child: _JourneyStrip(
                items: journeyItems,
                colors: colors,
                activeColor: brandColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _JourneyStrip extends StatelessWidget {
  final List<JourneyItem> items;
  final CustomColors colors;
  final Color activeColor;

  const _JourneyStrip({
    required this.items,
    required this.colors,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.sahiUtilityBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (index > 0)
                  Container(
                    width: 16,
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    color: colors.sahiTabBorder,
                  ),
                JourneyToolbarItem(
                  item: items[index],
                  colors: colors,
                  index: index + 1,
                  activeColor: activeColor,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _WatchButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color startColor;
  final Color endColor;
  final Color primaryColor;
  final bool muted;

  const _WatchButton({
    required this.onPressed,
    required this.startColor,
    required this.endColor,
    required this.primaryColor,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: muted ? null : LinearGradient(colors: [startColor, endColor]),
        color: muted ? startColor.withAlpha((0.1 * 255).round()) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: muted ? primaryColor : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_outlined,
                  size: 12,
                  color: muted ? Colors.white : primaryColor,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "Watch",
                style: TextStyle(
                  color: muted ? primaryColor : Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
